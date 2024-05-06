function langtonAnt(dimension, iterations) {
    // Initialize the grid
    let grid = Array(dimension).fill().map(() => Array(dimension).fill(0));

    // Calculate the starting position
    let x = Math.floor(dimension / 2);
    let y = Math.floor(dimension / 2);

    // Initialize the direction
    let direction = 0; // 0: left, 1: up, 2: right, 3: down

    // Perform the iterations
    for (let i = 0; i < iterations; i++) {
        // Flip the color of the current cell
        grid[y][x] = grid[y][x] === 0 ? 1 : 0;

        // Change direction
        if (grid[y][x]) {
            direction = (direction + 3) % 4;
        } else {
            direction = (direction + 1) % 4;
        }

        // Move the ant
        switch (direction) {
            case 0: x--; break; // Move left
            case 1: y++; break; // Move up
            case 2: x++; break; // Move right
            case 3: y--; break; // Move down
        }

        // Check if the ant has moved off the grid
        if (x < 0 || x >= dimension || y < 0 || y >= dimension) {
            break;
        }
    }

    // Convert the 2D grid to a 1D array
    let result = grid.reduce((acc, val) => acc.concat(val), []);

    return result;
}
let result = langtonAnt(80, 11000);

// Write to file
const fs = require('fs');

fs.writeFileSync('langton_ant.txt', result.toString());