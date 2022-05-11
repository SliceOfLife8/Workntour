#  NetworkLayer

NetworkLayer is the only in-app layer which can communicate directly with **Networking** module.

## Overview

NetworkLayer has three main goals:
- Communicate with Networking (DataManager class).
- Build api via Router (Router classes).
- Create domain models from api responses (Model classes).

NetworkLayer returns only  Combine’s operators like ``AnyPublisher``.
