# ``Networking``

Network layer which uses Apple's new framework Combine and provides async network calls with different kind of request functions.


## Overview

The main benefit is to abstract the networking layer as much as possible and remove redunant code from your projects as we know Apple announced a new framework called Combine the main goal is to provide a declarative Swift API for processing values over time. These values can represent many kinds of asynchronous events, so networking calls are the most important async events, which actually needs to have a support for Combine to prevent and integrate Apple's native framework. 
