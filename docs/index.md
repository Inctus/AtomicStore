# Introduction

## Description

AtomicStore is a lightweight wrapper allowing easy creation of custom DataStores ready for a pseudo-atomic DataBase on Roblox.

DataStores instanciated with this module abstract all the useless boilerplate code for safe lookups, and give you everything you need to implement features such as session locking and caching, whilst still allowing you the level of control you need to properly manage a pseudo-atomic transactional database on Roblox.

!!! warning "This module is aimed at high-level developers, and provides no inbuilt safeguarding or rate limiting."
	If you're looking for a simpler solution then see either [ProfileService by loleris](https://madstudioroblox.github.io/ProfileService/) or [DataStore2 by kampfkarren](https://kampfkarren.github.io/Roblox/).

## Project Layout

The project follows a simple modular layout, with the MainModule being `AtomicStore.lua`.

```
Lua/
	AtomicStore.lua
	Dependencies/
		Classes/
			GeneralStore.lua
			MultiStore.lua
			TrackedStore.lua
			TrackedMultiStore.lua
		Shared/
			Utility.lua
```

Here, the `Utility.lua` file contains a set of functions for safe access to DataStores, taking into account DataStoreBudgets and catching errors.

!!! tip "Use the installer to properly install the module and update it when you want to."
	This is properly documented in the installation guide.

## Why AtomicStore?

AtomicStore is a low level wrapper of pure datastores, preserving the same level of control and the accessibility you would get from creating your own system from scratch. If you're looking to create your own system, without dealing with unnecessary API, then this could be the option for you.

!!! note "The API for this store mimics Roblox's"
	It is simple, and intuitive to learn, and the data handling functions mimic the inbuilt DataStore functions meaning that it is really simple to learn and use this module, if you're used to working with pure DataStores.