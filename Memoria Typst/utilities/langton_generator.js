function langtonAnt(dimension, iterations) {
    // Initialize the grid. Doing it this way feels clean
    let grid = Array(dimension).fill().map(() => Array(dimension).fill(0));

    // Calculate the starting position at center
    let x = Math.floor(dimension / 2);
    let y = Math.floor(dimension / 2);

    let direction = 0; // 0: left, 1: up, 2: right, 3: down

    for (let i = 0; i < iterations; i++) {
        // Flip the color of the current cell
        grid[y][x] = grid[y][x] === 0 ? 1 : 0;

        // Change direction
        if (grid[y][x]) {
            direction = (direction + 3) % 4;
        } else {
            direction = (direction + 1) % 4;
        }

        // Move the ant. This order is important
        // Not getting this right will result in a "rotated" image when used in render
        switch (direction) {
            case 0: x--; break; // Move left
            case 1: y++; break; // Move up
            case 2: x++; break; // Move right
            case 3: y--; break; // Move down
        }

        // Check if the ant has moved off the grid (bounds checking)
        if (x < 0 || x >= dimension || y < 0 || y >= dimension) {
            break;
        }
    }

    // Mark the final position of the ant with the number 2 to render it differently
    // Really I shouldn't do bounds checking but just in case I messs while testing...
    if (x >= 0 && x < dimension && y >= 0 && y < dimension) {
        grid[y][x] = 2;
    }

    // Convert the 2D grid to a 1D array
    // This should really be done outside but meh, I'm just coding this quickly for to render the example in typst
    let result = grid.flat().join(',');

    return result;
}

let result = langtonAnt(80, 11000);

// Write to file
const fs = require('fs');

fs.writeFileSync('langton_ant.txt', result.toString());