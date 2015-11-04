---
uptitle: Draft Guidelines - Energy ADE version 0.6
title: CityGML Energy Application Domain Extension
dwtitle: In collaboration with OGC and SIG 3D
author:
- Romain Nouvel (RN)
- Marcel Bruse
- Olivier Tournaire
- Esteban Mu$\~n$oz (EM)
- \dots
date: October 1, 2014
footer: Guidelines - CityGML Energy ADE v0.6
bibliography: EnergyADE-library.bib
csl: chicago.csl
toc: 2
revision:
- comment: Basis version
  date: 03.08.2015
  who: RN
- comment: Markdown export
  date: 22.10.2015
  who: EM
institutes:
- University of Applied Sciences Stuttgart, Germany
- Technische Universität München, Germany
- Karlsruhe Institute für Technologie, Germany
- European Institute for Energy Research, Germany
- RWTH Aachen University / E.ON Energy Research Center, Germany
- HafenCityUniversität Hamburg, Germany
- Ecole Polytechnique Fédérale de Lausanne, Switzerland
- Centre Scientifique et Technique du Batiment, France
- Electricité de France, France
- Sinergis, Italy
- M.O.S.S Computer Grafik Système, Germany
abstract: |
    The Application Domain Extension (ADE) Energy detailed in this
    documentation defines a standardized data model based on CityGML format
    for urban energy analyses, aiming to be a reference exchange data format
    between different urban modelling tools and expert databases.

    It has been developed since May 2014 by an international consortium of
    urban energy simulation developers and users (University of Applied
    Sciences Stuttgart, Technische Universität München, Karlsruhe Institute
    für Technologie, RWTH Aachen University / E.ON Energy Research Center,
    HafenCity Universität Hamburg, European Institute for Energy Research,
    Ecole Polytechnique Fédérale de Lausanne, Centre Scientifique et
    Technique du Batiment, Electricité de France, Sinergis and M.O.S.S
    Computer Grafik Systeme).
---

Overview of the Application Domain Extension Energy
===================================================

Following the philosophy of CityGML, this ADE Energy aims to be flexible, in
terms of compatibility with different data qualities, levels of details, and
urban energy models complexities (from monthly energy balance of ISO 13790, to
sub-hourly dynamic simulation of softwares like CitySim or EnergyPlus). It
takes into consideration the INSPIRE Directive of the European Parliament, as
well as the recent US Building Energy Data Exchange Specification (BEDES).

Its structure is thought of as modular; some of its modules can be potentially
used and extended for other applications (e.g. module Occupancy for
socio-economics, module Materials for acoustics or statics, module Metadata and
Scenarios for every urban analysis).

ADE Energy Core
===============

The Core of the ADE Energy contains the thermal building objects required for
the building energy modelling. These thermal building objects are linked to the
CityGML building objects through its `_AbstractBuilding`, `_BoundarySurface`
and `_Opening` classes.


Overview
--------

![Class diagram of ADE Energy Core - Geometrical Part](fig/class_geometry.png)

![Class diagram of ADE Energy Core - Time Series](fig/class_time.png)

![Class diagram of ADE Energy Core - Schedules](fig/class_schedules.png)

\newpage

Building, zones and boundaries
------------------------------

**ThermalZone**

Zone of a building which serves as unit for the building heating/ cooling
simulation. For the simulation, a thermal zone is considered as isothermal. It
is a semantic object, which may be or not related to a geometric entity
(Building, BuildingPart, Room etc.).

This class inherits from `_CityObject`, and may therefore be associated to 1
or more EnergyDemand objects (see module Energy systems).

For the requirement of the building heating/cooling simulation, the ThermalZone
must be related to one or more UsageZone.

**UsageZone**

Zone of a building with homogeneous usage type.

This class inherits from `_CityObject`, and may therefore be associated to 1
or more EnergyDemand objects. This class is defined minimally by a usage zone
class and a used area.

For further details, see module Occupancy.

**ThermalBoundarySurface**

Quasi-coplanar surface bounding the thermal zone. It may be linked to the
`gml:BoundarySurface` (through the `ADE:_BoundarySurface`) when possible, but
not necessary (e.g. cellar ceiling or top storey ceiling in the case of
LOD1-3).

This class inherits from `_CityObject`, and may therefore be associated to a
Construction Object (see module Construction and Material).

**SurfaceComponent**

Part of the thermal boundary surface corresponding to a homogeneous
construction component (e.g. windows, wall, insulated part of a wall etc.).

This class inherits from `_CityObject`, and may therefore be associated to a
Construction Object (see module Construction and Material).

**\_AbstractBuilding**

Extension of CityGML object `_AbstractBuilding` in Application Domain
Extension Energy.

**\_BoundarySurface**

Extension of CityGML object `_BoundarySurface` in Application Domain Extension
Energy.

Even empty, this subtype is necessary for the connection of the ADE Energy to
the CityGML, since a bi-directional associations to the existing definitions is
added.

**\_Opening**

Extension of CityGML object `_Opening` in Application Domain Extension Energy.
Openings may have an indoor and an outdoor shading system. They are further
defined by an openable ratio.

Time Series
-----------

Time Series are used in the Energy ADE for energy amount or schedule modelling
for instance. Given that the class Time Series is not specific to the Energy
ADE, it should be integrated in the CityGML Core at middle-term.

Time series are homogeneous list of time-depending values.

These values are defined for a specific *temporalExtent* (= start, end and
duration time). They have common properties specified in the type

**TimeValuesProperties**.

These properties are the variable label, the variable unit of measure (*uom*),
the interpolation type (based on the [WaterML
ADE](http://def.seegrid.csiro.au/sissvoc/ogc-def/resource?uri=http://www.opengis.net/def/waterml/2.0/interpolationType/))
and some data acquisition information like the data source, the acquisition
method and the quality description.

Time Series can be either regular or irregular.

**RegularTimeSeries** contain *values* generated at regularly spaced interval
of time (*timeInterval*). They are relevant for instance to store automatically
acquired data.

In **IrregularTimeSeries**, the data in the time series follows also a temporal
sequence, but the measurement points might not happen at a regular time
interval[^1]. Therefore, each value must be associated with a data or time.

Schedules
---------

The type Schedule is used in the ADE Energy for different kinds of schedules
and variables, including heating/cooling schedules (set-point temperatures),
ventilation schedules (mechanical air change rate) and occupancy rate.

Schedules may be modelled with 4 Levels of Details (,LoD) depending on the
available information and the application.

**Schedule LoD 0**

Constant value, generally corresponding to the average parameter value.

```xml
<energy:operationSchedules>
    <energy:ScheduleLoD0>
        <energy:averageValue uom="">10</energy:averageValue>
    </energy:ScheduleLoD0>
</energy:operationSchedules>
```

**Schedule LoD 1**

Two-state schedule, specified by a usage value defined for usage times, and an
idle value outside this temporal boundaries. Information about the approximate
number of usage days per year and usage hours per usage days are also defined
(if these days are precisely known, then the schedules LoD2 or LoD3 may be used
instead).

This Schedule LoD 1 complies in particular with the data requirements of the
Codes and Norms describing the monthly energy balance (DIN 18599-2, ISO 13790).

**Schedule LoD 2**

Detailed schedule composed of daily schedules associated to recurrent day types
(weekday, weekend etc.).

These daily schedules are Time Series as described above.

**Schedule LoD 3**

Detailed schedule corresponding to a Time series as described above.

Construction and Material Module
================================

![Class diagram of Construction Module](fig/class_construction.png)

The Construction and Material is a module of the ADE Energy, which may be
extended for multi-field analysis (statics, acoustics etc.). It contains the
physical characterization of the boundary surfaces, surface components and even
whole building (and potentially all the objects which inherits of
`_CityObject`).

Construction and layers
-----------------------

**Construction**

Physical characterisation of building envelop or intern room partition (e.g.
wall, roof, openings), it may be specified as an ordered combination of layers.

The object Construction may be associated to the (thermal) boundary surfaces,
surface components, buildings (and potentially all the objects which inherits
of `_CityObject`).

It inherits itself from `_CityObject`.

**ConstructionOrientation**

Class defining the orientation convention of the Construction, it means the
order of the layers. A same Construction, common to different zones or
buildings, will be orientated in two different directions for instance.

**Layer**

Combination of one of more materials, referenced via a layer component.

It inherits from `_CityObject`.

**LayerComponent**

Homogeneous part of a layer, covering a given fraction (*areaFraction*) of the
layer.

Materials
---------

**AbstractMaterial**

Abstract superclass for all Material classes. A Material is a homogeneous
substance. We distinguish opaque materials, glazings and gas.

<!--- RN 22.01.2015
Not optimal: rather distinguish "Materials" from "NoMassMaterials" and
associate "Glazing" to "LayerComponent"
-->

**OpaqueMaterial**

Class of the materials which are opaque.

**Glazing**

Transparent component, which may count one or more panes. It is specified by
its hemispherical/normal transmittances, emittances and reflectances.

<!--- RN 16.01.2015
Not exactly an homogeneous substance -> replace by class OpticalProperties?
(for Construction, LayerComponent or SolidMaterial?)
-->

Optical properties
------------------

**Emittance**

Ratio of the radiation emitted by a specific surface /object to that of a black
body.

It is specified for a given surface (SurfaceSide), for a given wavelength range
type (solar, infrared, visible or total).

**Absorptance**

Fraction of incident radiation which is absorbed by an object.

It is specified for a given surface (SurfaceSide), for a given wavelength range
type (solar, infrared, visible or total).

According with the Kirchoff and Lambert law, for a diffuse grey body (then
non-metallic, non-transparent), the aborptance and the emittance are equals for
a given wavelength range.

**Reflectance**

Fraction of incident radiation which is reflected by an object.

It is specified for a given surface (SurfaceSide), for a given wavelength range
type (solar, infrared, visible or total).

**Transmittance**

Fraction of incident radiation passes through a specific object.

It is specified for a given wavelength range type (solar, infrared, visible or
total).

The sum of the absorptance, reflectance and transmittance of a surface/object
is always 1.

Occupancy Module
================

![Class diagram of Occupancy Module](fig/class_occupancy.png)

The Occupancy Module is a module of the ADE Energy, which may be extended for
multi-field analysis (socio-economics, demographics etc.).  It contains the
characterization of the building usage, it is related to the rest of the ADE
Energy and CityGML model through the unique class `UsageZone`.

Usage zone and Building Unit
----------------------------

**Usage Zone**

Zone of a building with homogeneous usage type. This usage type is defined by a
*usageZoneClass* (corresponding to the CityGML Code list of the
`_AbstractBuilding` attribute class).

This zone is operated with a single heating and cooling set-point temperature
schedule (*heatingSchedule* respectively *coolingSchedule*) and single air
ventilation schedule.

It inherits from `_CityObject`.

**BuildingUnit**

Part of usage zone which is related to a single occupant entity, such as
dwelling or workplace. Owner information data (as owner name and ownership
type) are specified in this class.

It inherits from `_CityObject`.

Occupants
---------

**Occupancy**

Homogeneous group of occupants of a usage zone or building unit, defined with
an occupant type (e.g. residents, workers, visitors etc.).

**Household**

Group of persons living in the same dwelling, in the case where occupants are
residents.

There are defined by a type (e.g. one family, worker couple etc…) and a
residence type (main/secondary residence or vacant).

Facilities
----------

**Facilities**

Facilities and Appliances inside the usage zone or building unit, which consume
and dissipate energy. They are distinguished between domestic hot water
facilities (*DHWFacilities*) and electrical facilities

Energy System Module
====================

![Class diagram of Energy System Module](fig/class_EnergySystem.png)

![Type classes of Energy System Module](fig/class_EnergySystemClass.png)

The Energy System Module is a module of the ADE Energy, which contains the
information concerning the energy forms (energy demand, supply, sources) and
the energy systems (conversion, distribution and storage systems).

Energy Amounts and Forms
------------------------

**EnergyDemand**

Useful energy required to satisfy a specific end use, such as heating, cooling,
domestic hot water etc… These end uses are listed in **EndUseType**.

Every `_CityObject` may have one or more `EnergyDemand`.

**EnergySupply**

Part of the energy produced by the energy conversion systems which is supplied
to satisfy the end use demand of a city object.

**EnergySource**

Final energy consumed by the energy conversion system.

Its energy characteristics (primary energy and CO2 emission factors, energy
density, energy carrier type) are specified in the Energy Carrier object.

Energy Distribution
-------------------

**EnergyDistributionSystem**

System in charge of delivering the energy inside the building, from the place
of energy production to the place of end-use. Power and Thermal distribution
systems are differentiated.

**StorageSystem**

System storing energy. A same storage may store the energy of different
end-users and different end uses. Power and Thermal storage systems are
differentiated.

**EndUseUnit**

Final device(s) which deliver the required energy to the end-user in his
end-use place (e.g. radiators or convectors for heating etc.)

Energy Conversion
-----------------

**EnergyConversionSystem**

System converting an energy source into the energy necessary to satisfy the
end-use (or to feed the networks).

Energy conversion systems have common parameters: nominal installed power,
nominal efficiency (in reference to an efficiency indicator), year of
manufacture, name of the model. They may be one or more (in this case, the
nominal installed power corresponds to the totality). Some product and
installation documents may be referenced.

Specific energy conversion systems may have in addition specific parameters:

A same system may have several operation modes (e.g. heat pump covering heating
and domestic hot water demands).

**OperationMode**

It details the operation of the energy conversion system for a specific end-use
and operation time. For instance, a reversible heat pump may have 3 operations
modes: heating production in winter, cooling production in summer, and hot
water production during the whole year.

**EnergyCoverage**

It determines the coverage rate (may be time depending) of a given energy
supply by a given operation mode of an energy conversion system.

[^1]: [IBM knowledge Center](../customXml/item1.xml)