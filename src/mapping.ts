import { BigInt } from "@graphprotocol/graph-ts"
import { PoolFactory, PoolCreated } from "../generated/PoolFactory/PoolFactory"
import { PoolEntity } from "../generated/schema"

export function handlePoolCreated(event: PoolCreated): void {
  let entity = PoolEntity.load(event.params.poolAddr.toHexString())

  // Entities only exist after they have been saved to the store;
  // `null` checks allow to create entities on demand
  if (!entity) {
    entity = new PoolEntity(event.params.poolAddr.toHexString())
  }

  // Entity fields can be set based on event parameters
  entity.poolName = event.params._poolName
  entity.endDate = event.params._endDate
  // Entities can be written to the store with `.save()`
  entity.save()
}
