## Company => Users Challenge

### Introduction

This repository presents a code challenge that involves parsing two JSON files, namely
`companies.json` and `users.json`, processing their contents, and generating a report that
facilitates data visualization by grouping.

### Requirements

- **Ruby Version:** This code is compatible with Ruby 2.7 and above, but it's recommended to
use Ruby 3.2 for optimal performance.
- **Platform Compatibility:** The code has been thoroughly tested on Windows, Linux, and macOS to
ensure correctness.
- **Dependency-Free:** The solution relies solely on the Ruby Standard Library, avoiding external
dependencies for simplicity amd portability.

### Usage

To witness the solution in action, follow these steps:

1. Clone this repository to your local machine.
2. Run the `ruby challenge.rb` command in your terminal.
3. To execute the tests, run `ruby test/runner.rb`.

### Solution Considerations

#### All-in-One File

The entire code for this challenge resides within a single file, `challenge.rb`. While this
design choice consolidates the solution for portability, the business logic is logically
organized into multiple classes. The tests are segregated into multiple files for better readability.

#### No External Dependencies, Sorbet Annotations

This solution doesn't rely on external libraries. However, the code includes [Sorbet-style](https://sorbet.org)
annotations for method signatures to improve code readability and comprehension. These
annotations are commented out in the code due to the decision not to include external libraries.

#### Standalone Ruby Code

The Ruby code can be executed directly by invoking the Ruby command-line. When imported into
another file, it is loaded but not automatically executed, allowing for flexibility in running
tests.

#### Explore Git History

The Git history of this repository offers insight into the iterative development process.
Starting from the initial commit, you can trace the evolution of both the code structure and the
tests, illustrating the importance of careful planning and refinement in achieving a robust
solution.
