# Stats

### Creature Stats
- NPCs take damage.
- Hit Points (HP) — A creature dies when HP reaches 0 or less.
- HP Pools — The player and some enemies have a number of HP pools. When one is depleted, any remaining damage is ignored. This means that nothing can be killed in fewer hits than their total HP pools, including the player.
- Move Speed — Speed the character moves through space.
- Jump Height — How high the enemy jumps.
- Detection Range — How close the character needs to be before the creature attacks.
- Any additional necessary stats.

### Attack Stats
- Damage — The amount of HP removed by a single Hit.
- Speed — How quickly the attack is executed.
- Cooldown — The time before another attack can be made.
- Knockback — Distance opponent is pushed on hit. Negative values draw the opponent toward the user.
- Recoil — Distance the user is pushed when the attack is used, whether whiff or hit.
- Any additional stats.

## Enemy Implementation
- [ ] Enemies take damage (hurtboxes)
- [ ] Enemies deal damage (hitboxes)
- [ ] Enemies have HPPs
- [ ] Enemies die when primary HPP </= 0
- [ ] Enemies respawn on Rest
- [ ] Enemies attack only when aggro'd