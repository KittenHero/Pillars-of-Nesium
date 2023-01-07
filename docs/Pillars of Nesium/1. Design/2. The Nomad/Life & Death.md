# Life & Death

# Mechanics

- [x]  UI Elements
    - [x]  Health Bar / Spirit Gauge
- [ ]  Player Mechanics
    - [x]  Taking Damage
    - [x]  Dying
    - [ ]  Restoring Spirit
- [ ]  NPC Mechanics
    - [ ]  Taking Damage
    - [ ]  Dying
    - [ ]  
    - [ ]  Respawning on player death
- [ ]  Animations
    - [ ]  Taking Damage
    - [ ]  Dying
    - [ ]  Re-spawning
    - [ ]  Restoring Depleted Spirit
    - [ ]  Restoring partially-depleted spirit

## **Health**

Hit Points (HP) & HP Pools (HPP) — Characters die when all of their HP pools reach 0 or less. The player, bosses, and some enemies have more than one HP pool.

When one HP pool is depleted, any remaining damage is ignored — it does not carry to the next HP pool. This means that nothing can be killed in fewer hits than their total HP pools, including the player.

The player begins with two HP pools, each with (1) HP — the Guardian Spirit, and the character himself. Only the Guardian Spirit's HP pool can improve.

## Payer Health

### The Guardian Spirit

The character is fragile, but guarded by a powerful guardian spirit. This spirit protects the player from damage, but once gone, any further damage will kill the player. It is restored at checkpoints, or by dealing enough damage to enemies.

**Upgrades** can improve this guardian spirit, effectively granting the player a larger health pool. 

The player can expend the Guardian Spirit’s energy to cast **spells** — BIG MAYBE

### Damage

Most damage simply removes one point of HP. The Guardian Spirit & Player both start with 1 HP, effectively granting the player 2 HP.

Some attacks, from particularly dangerous foes or hazards, will deplete the player’s Guardian Spirit in one blow, regardless of how much HP it has. This attacks are typically telegraphed.

The player can never die in one hit as long as some Guardian Spirit HP remains.

When the player suffers damage, there is a very small window of invulnerability. Just barely enough time to escape danger. The blaster is a good panic button for escaping danger when invulnerable.

### Beyond Damage

Some attacks do more than simply damage a character. Enemy attacks may knock the player back to varying degrees. While the player takes no fall damage, he may be knocked into hazards or other enemies.

Player attacks, especially from the blaster, may knock enemies around.

### Restoration

A depleted Guardian Spirit can be restored, and when it is, all of its energy is restored. This makes Guardian Spirit restoration more and more useful as its HP pool increases. The PC himself never needs to recover health because he always dies in one hit. 

Restoration occurs when resting at a Fountain, or when enemies are killed. Fountains restore all HP. Killed enemies restore Spirit based on enemy power.

### **Death**

Causes the player to respawn at the previous checkpoint, restored by the Guardian Spirit.

### The Death Penalty

All enemies in the game respawn. The player’s skeleton is revived as a tough enemy - it does not need to be killed, but does not respawn if it is. The game keeps a tally of each of their skeletons that *************isn’t killed*************. Later, when the Nomad fights his skeleton, many weaker skeleton versions appear = to this tally.