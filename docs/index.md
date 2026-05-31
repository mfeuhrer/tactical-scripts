# Welcome to my RMM Documentation

I've spent most of my professional career working for Managed Service Providers, and much of my focus during that time has been around automation. RMM based automation specifically. 

Throughout this adventure, I've had the opportunity to work with a number of RMM platforms and utilities and while they all do some thing differently, at the end of the day, they are largely interchangeable. 

At home, I leverage [Tactical RMM](https://tacticalrmm.com) to manage my lab environment. I appreciate that it is open source and allows me a playground of sorts to experiment outside of work. It has a fairly robust API for introducing RPA tools like n8n and supports PowerShell scripts natively, instrumental when managing Windows fleets. 

This repository and documentation contains scripts I've written on my own time and with my own resources. While some goals may overlap professionally, this is all my code and is free to use for your own purposes.

## Where to Start

If you're familiar with RMM in general, or Tactically specifically, jump right in to the code. Most scripts should have enough documentation inside of them to replicate usage in your own environment with little modification.

If you're new to all of this, check some of the below resources. These should help explain my approach to architecture, my scripting methodology, and how some of these items work with each other.

* [Methodology](./about/script-methodology.md) - Learn how I write scripts. A little look inside my brain
* [Why PowerShell](./about/why-powershell.md) - Find out why PowerShell is the dominant language for MSPs.
* [Who, Me?](./about/about-me.md) - Who the hell am I, and why should you care?
* [AI Disclosure](./about/ai-disclosure.md) - Learn how I'm using AI. It doesn't involve vibes. 

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.
	scripts/
		checks/ # Scripts to use for health checks. Useful for conditions or monitors.
		gathering/ # Scripts to get system information. 
		installs/ # Scripts for installing software or features.
		maintenance/ # Scripts for maintaining devices, like disk cleanups or configuration resets.
		removals/ # Scripts for removing software, features, or files
		snippets/ # Scriptlets to be imported as functions to other scripts. Super useful for repeated and common functions. 
	resources/ # Assets such as config files or other scripts that are downloaded to an end device