#  NetworkLayer

NetworkLayer is the only in-app layer which can communicate directly with **Networking** module.

## Overview

NetworkLayer has three main goals:
- Communicate with Networking.
- Build api.
- Transform domain models into business models.

NetworkLayer returns only  Combine’s operators like ``AnyPublisher``.
