# 0002 Modular monolith (api + worker) behind ports
- Status: Accepted
- Context: A t3.micro has 1 GiB RAM; many microservices will not fit and add ops overhead.
- Decision: Two Go binaries (api, worker). Domain packages communicate through interfaces; infra (cache, queue, search, storage, media) behind ports with free and scale adapters.
- Alternatives: microservices from day one; single binary.
- Consequences: fits the free profile; extraction into services later is mechanical (package -> cmd). Enforce boundaries with lint (no cross-domain imports of internals).
