# Abilities

# Design Notes

Speed, maneuverability, agility. The character is a desert nomad. Swift, light on his feet, he dodges and deflects, avoiding danger. Thus, none of his moves should make the player feel slow

The Nomad should feel fast and fluid. He should be comfortable and deft in his movements, like the skilled warrior nomad he is.

The Nomad’s default abilities should also make “sense”, insofar as you can do everything you would expect you can. Running, crawling, jumping, fighting. Different varieties of jumps including long, high and regular. You can crouch, crawl, slide. Each movement should easily chain into the next and able to be ‘cancelled’, i.e no locking you into long animations.

After a first stage that lets you come to grips with basic movement, you’ll be introduced to the blaster, a powerful weapon that doubles as a traversal tool, enhancing your slides and jumps with powerful bursts of thrust.

The gravity will be low for two reasons: To make the player feel more in control and give them time to react, and because lore-wise this section of the world has low gravity.

Feedback: For the more difficult and precise maneuvers such as blast-sliding, feedback should be given to the Player to show that he has done the move correctly.

# List

For more details, view the descriptions section. Any ability with a ‘lock’ icon refers to an unlockable ability.

- Utility
    - [ ]  Look Mode
- Platforming
    - [ ]  Move Left / Right
    - [x]  Jump
    - [x]  Crouch
    - [ ]  Crawl
    - [ ]  High Jump
    - [x]  Slide
    - [x]  Long Jump
    - [ ]  Wall Grip
    - [ ]  Wall Jump
    - [ ]  Wall Slide
    - [ ]  Roll
    - [ ]  Air Dash
    - [ ]  Blaster Slide
    - [ ]  Blaster Hop
    - [ ]  Blaster Launch
- Combat
    - [ ]  Standing Melee
    - [ ]  Forward Melee
    - [ ]  Jump Melee
    - [ ]  Slide Melee
    - [ ]  Charge Melee
    - [ ]  Deflect
    - [ ]  Blaster

# Descriptions

## Utility

### Look Mode

Normally the camera is fixed, but by holding down the Look Mode button, the camera is freed to an extent. This allows the player to see further than normal, potentially glimpsing hidden areas.

Prevents the player from moving whilst active.

## Platforming

### Move Left / Right

The Nomad runs to the left and right.

### Jump

Variable jump.

Fixed or variable? Need testing. Leaning toward fixed.

### Crouch

Crouching prevents recoil and low-profiles certain attacks. Important for using blaster on tiny platforms.

### Crawl

Move + crouch. The crawl will be fast, like an animal running on all fours.

### High Jump

Crouch + Jump

A higher than normal Jump straight upward - minor lateral adjustment.

### Slide

The character will perform a short but quick slide along the ground, fixed distance. Low-profiles some attacks and projectiles like the crouch. Has i-frames, allowing one to dodge melee attacks and move through enemies. However, i-frames don't count for projectiles.

### **Long Jump**

Slide + Jump

Jumping during a slide will perform a jump that is longer than normal, but with less height.

### 🔒Wall Grip

Jump + Move to wall

You’ll grip onto and slowly slide down a wall.

### 🔒Wall Jump

Whilst using Wall Grip → Jump

You’ll launch yourself off the wall

### 🔒Wall Slide

Wall Grip + Slide

You’ll slide directly down the wall, and roll along if it holding Slide.

### 🔒Roll

Hold: Slide

Holding the slide key will cause the player to enter a roll. Rolling causes the character to curl into a ball and retain current momentum, but prevents manual acceleration. This is meant to be used in tandem with the weapons and obstacles in the environment. For example, firing the blaster to gain momentum, then rolling to preserve momentum to traverse an area quickly, or roll up a ramp at high speed.

Pressing the 'slide' 'crouch' or key will exit the roll. Pressing the 'jump' key will cause the player to jump out of the roll.

Consider top speed. Don't want sonic levels.

### 🔒Air Dash

Jump + Slide

Unlocking the Air Dash also unlocks i-frames for the slide.

### 🔒Blaster Slide

Firing the blaster during a slide will dramatically increase the speed of the slide, and the subsequent roll. A small sound effect and burst of light will indicate when the player has timed

### 🔒Blaster Hop

Firing the blaster at an angle between 91 and 269 degrees will launch the player into the air.

### 🔒Blaster Jump

Firing the blaster midair will propel the player quickly in the opposite direction.

## Combat

### Forward Melee

Move + Melee

Player has a scimitar. Short range directional (up, across, down) melee with minor recoil & knockback on hit. Player must use this for the first segment of the game, until he unlocks the Blaster.

Player should be able to melee and move at the same time. 

10 Damage

Upgrades: Increase range, damage.

### Standing Melee

Same as Melee but with different animation.

### Jump Melee

### Crouch Melee

### Slide Melee

Slide + Melee

Attacking during a slide will perform a slide attack, which has a larger hitbox and reach.

### 🔒Charge Melee

Hold: Melee

### 🔒Deflect

Use the scimitar to deflect projectiles, returning them to sender.

### 🔒Blaster Shot

Fires a short range blast with a large Area of Effect and high recoil.

- X Damage
- High Knockback
- High Recoil
- Longer range than melee, still very short range.
    - In combat, it requires the player to get up-close-and-personal with enemies.
- ~~Reflects Projectiles~~
- Creates gaps in waterfall / sandfall hazards
- 1—2s Recharge: Only while on foot

**[Upgrades](Unlockables.md)**

##