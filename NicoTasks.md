06-09-2023
- Implemented IMGUI, OpenGL and did a basic simulation rendering to a quad (just sand falling)

13-10-2023
- Code analysis, wrote down possible future problems and thought solutions

14-10-2023
- Code analysis, minor corrections
- Thought more in deep about yesterday proposed solutions

15-10-2023

- Refactored goDown and goDownSide methods. 
- Thought more about how to refactor the rest taking advantage of what we had to not loose time and keep it scalable

17-10-2023

- Added computeIndex method accounting for l and r values
- Thought about implementation problems and scalibity and how to fix them
- I made goDown, goDownLeft and goDownRight return how many pixels to move are left
- Refactored goDownDensity, pushOtherParticle. Restructured updateSand and updateWater