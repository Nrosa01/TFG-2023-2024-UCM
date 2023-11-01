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
- Check physical interactions (this step can stop the simulation for this particle, density, temperature, etc)
- Check quimic interactions (this step can stop the simulation for this particle)
- Repeat until velocity reaches 0 or a physical or quimic interaction stops the simulation for this particle

* We should define a particle movement structure like this

Question: What's more important, quimics or physics interactions? I think both can work but we need to think about this.

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
  int lifetime;
  int temperature;
};
```

## Particle definitions

Particles itself are defined by an string and an int, so it can be accessed both ways. The particle data is a vector of particle data. Particle data
is a struct that contains particle type id (string, int), physics properties struct and quimic interactions struct.

```cpp
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

General Algorithm pseudo-code in C++

```cpp
// Notes: Instead of trying to move the particle all the pixels at once, we are
// moving one by one, so if this particle emits heats or something we can account for that in each iteration
// It might be slower than moving in each pass directly until collision but it's more accurate. I think we can go with this for now
inline void simulateParticle(uint32_t particleIndex)
{
  // Get pixels to move from particle constant data
  const uint32_t particleDataIndex = chunks[particleIndex].id;
  const uint32_t particleMovementPassesAmount = particleData[particleDataIndex].particleMovementPassesAmount; // This is a value because using a value for this is not worthy to just store a few structs
  uint32_t pixelsToMove = particleData[particleDataIndex].pixelsToMove;
  bool particleIsMoving = true;
  bool particleCollidedLastIteration = false;
  uint32_t particleMovementPass = 0;

  while(pixelsToMove > 0 && particleIsMoving)
  {
    // Gather particle first direction pass
    int32_t particleMovementX = particleData[particleDataIndex].particleMovement[particleMovementPass].X;
    int32_t particleMovementY = particleData[particleDataIndex].particleMovement[particleMovementPass].Y;

    // Move particle until collision
    // This method moves the particle only once and remains the remaining pixels to move
    // If the remaining equals the pixels to move, it means the particle couldn't move at all (collision)
    uint32_t remainingPixelsToMove = moveParticle(particleIndex, particleMovementX, particleMovementY, pixelsToMove); // inline this pls

    // This could probably be simplified but as long as it works, it's fine for now
    // You might think we could just check wheter particleMovementPass is greater than movementPass.length and use that to stop. But that won't be correct, as we might have reached that pass but still have pixels to move and loop again through the passes to try to move the remaining pixels in the next iteration that we couldn't before (because of a collision) but now we can because the other passes displace the particle in a way that it can move again.
    if (remaningPixelsToMove == pixelsToMove)
    {
      // Increment movemnetPass looping through the passes
      particleMovementPass++;

      // If we reached the last pass, reset to the first one
      //  I know we could creat a loop func for this but given this is simple, it's not worth it
      if (particleMovementPass >= particleMovementPassesAmount)
        particleMovementPass = 0;

      
      if (particleCollidedLastIteration)
        particleIsMoving = false; // If the particle collided last iteration and this one, it means it can't move at all
      
      particleCollidedLastIteration = true;
    }
    else
    {
      particleCollidedLastIteration = false;
      particleIsMoving = true;
    }

    // This boolean can be called differentely and might be changed by physics or quimic interactions, as the particle might move on these stages.
    // But we need something like this to avoid an infinite loop

    // Check if any physic interaction can occur
    if (getPhysicInteractions(particleIndex)) // Returns true if any physic interaction can occur
    {
      //Handle physics

      // Usually, once physics are handled, the particle process is stopped
      // We put pixelsToMove to 0 instead of return to check for quimic interactions
      pixelsToMove = 0;
    }

    // Check if any quimic interaction can occur
    if (getQuimicInteractions(particleIndex)) // Returns true if any quimic interaction can occur
    {
      //Handle quimics

      // Usually, once quimics are handled, the particle process is stopped
      pixelsToMove = 0;
    }

    // Repeat until velocity reaches 0 or a physical or quimic interaction stops the simulation for this particle
  }
}
```
