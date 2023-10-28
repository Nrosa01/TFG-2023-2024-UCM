## Particle types

- Liquids
  - Water
  - Acid
  - Poison
  - Lava
  - Oil
  - Mercury
  - Alcohol
  - Gasoline
  - Milk
  - Blood
  - Ink
- Solids
  - Rock
  - Sand
  - Wood
  - Metal
  - Ice
  - Snow
  - Salt
  - Glass
  - Diamond
  - Gunpowder
- Gas
  - Common Gas
  - Smoke
  - Steam
  - Chlorine
  - Hydrogen
  - Oxygen
  - Nitrogen
  - Carbon Dioxide
  - Helium

Constants Particle have:
- Density
- Color
- Size
- Flammability
- Explosiveness
- Boiling point
- Starting temperature
- Fall speed
- Spread speed

Variables Particle have:
- Position (harcoded via index)
- Lifetime / Duration
- Temperature

Kind of interactions:

- Particle - Particle
  - Push
  - Swap
  - Destroy
  - Explode
  - Burn (maybe we need burn accumulator variable)
  - Freeze (for liquids)
  - Evaporate (if temperature > boiling point)
  - Condense (if temperature < boiling point, define how particles affect temperature, maybe we need a tempereature map)
  - Dissolve (think about this)
  - Corrode (for solids and liquids but not gases, this is what acid does)
  - Fuse (for example, lava and water makes rock)
- Particle - Self
  - Burn (maybe we need burn accumulator variable)
  - Freeze (for liquids)
  - Evaporate (if temperature > boiling point)
  - Condense (if temperature < boiling point, define how particles affect temperature, maybe we need a tempereature map)

Properties are repeated, when a lava particle hits another particle, this particle gets heated and this migh trigger an interaction. On the other hand, it might have gathered temperature from ambient and self check itself to see wheter a quimical interaction is triggered.

The Particle - Particle can be avoided, we could just check in the next particle iteration its self interactions instead of doing it in the current particle iteration, this can also improve performance.

## Algorithm:

- Gather particle velocity
- Move particle until collision
  - Check if particle is in bounds
  - Execute current pass
  - If fail, try next pass
  - If all passes fail but at least one pass was executed, retry from the first pass. If not, stop simulation for this particle
- Check quimic interactions (this step can stop the simulation for this particle)
- Check physical interactions (this step can stop the simulation for this particle, density, temperature, etc)
- Repeat until velocity reaches 0 or a physical or quimic interaction stops the simulation for this particle

* We should define a particle movement structure like this

```cpp
struct ParticleMovement {
  sign X; //Sign can be -1, 0 or 1 (we'll just use an int for that)
  sign Y;
};
```

We will have this as a constant in the particle Data, so a particle might have various particleMovement passes. If one pass can't be done, the next one will be tried, until all passes are done or a physical or quimic interaction stops the simulation for this particle.

## Particle struct

```cpp
struct Particle {
  int type;
  int x;
  int y;
  int lifetime;
  int temperature;
  int velocityX;
  int velocityY;
};
```

## Particle definitions

Particles itself are defined by an string and an int, so it can be accessed both ways. The particle data is a vector of particle data. Particle data
is a struct that contains particle type id (string, int), physics properties struct and quimic interactions struct.

```cpp
struct ParticleData {
  std::string name;
  int id;
};

struct ParticleData {
  std::string name;
  int id;
  PhysicsProperties physicsProperties;
  QuimicInteractions quimicInteractions; // This should be something apart as it's built later, this is the temp one idk
};

ParticleData* particleData;
```

## Physics properties

```cpp
struct PhysicsProperties {
  int density;
  int color;
  int flammability;
  int explosiveness;
  int boilingPoint;
  int startingTemperature;
  int fallSpeed;
  int spreadSpeed;
};
```

## Quimic interactions
    
I think quimic interactions should be a map or array static created during particle creation.
So if you create a water particle, you will want to add its interaction with lava, whose result is rock. 
At the same time, when adding lava, you will want to add its interaction with water, whose result is rock.
But chances are lava hasn't been added when water is added and viceversa. So for this map, we should use the string id of the particle.
Once all interactions are defined, we can build the real structure. Both accesing water and lava quimical interactions should be O(1).
And both should return the same result, rock, we don't want to repeat quimic interactions in both directions. Quimic interactions are always bidirectional.

We need two structures for this, the temporal one, and the real one built from the temporal one.

Quimics interactions are defined above, when two particle collides, these can result in a new particle: water + lava = rock or acid + anythingCorrsive = nothing but acid might or not persist. This also works for self particle interactions, water + high temperature = steam.
Every possible quimic interaction is defined here, both for particle-particle and particle-self interactions.

```cpp

// This is the temporal one, it's built from the particle data
struct TempQuimicInteractions {
    string particleId; // This is the particle that will interact with the other one
    string otherParticleId; // This is the other particle that will interact with the particle

    // This is the result of the interaction
    // Figure out how to define quimic interactions throu code
    // Maybe we can use an enum of kinds of interactions idk
};
```