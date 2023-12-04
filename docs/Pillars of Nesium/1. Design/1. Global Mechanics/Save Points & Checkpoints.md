## Save Points & Checkpoints
### Primary Checkpoint / "Save Point"
**Appearance**: Fountain
- [ ] The Nomad respawns at the most recently used checkpoint on Death
- [ ] Plays the Rest Theme until the player leaves the Save Point Room
- [ ] Activating save point for first time changes animation
- [ ] *Player can Rest at save point*: At the save point, the player can Rest, which activates the save point. Doing so causes the following to occur:
	- [ ] Replenishes HPP1
	- [ ] Respawns all Enemies

### Secondary Checkpoint / "Checkpoint"
Appearance: None
At certain points, secondary checkpoints are placed. When the player's position needs to be reset, for example after fallinginto a pit hazard, the secondary checkpoint is used.
- [x] Player position reset to checkpoint when taking Reset damage.
- [ ] Reset animation implemented.