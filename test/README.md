# Test README for Bash Command Extraction

This file tests the bash command extraction script.

## Basic Commands

Commands are code blocks marked by `sh` or `bash`.

Here's a simple command:

```bash
echo "Hello World" # Some comments
```

## Multi-line Command

A command split across multiple lines:

```sh
echo "This is a long command that" \
     "spans multiple lines" \
     "for better readability"
```

## Multiple Commands

Several commands in one block:

```bash
# Initialize variables
NAME="Test User"
AGE=30

# Print information
echo "Name: $NAME" && \
echo "Age: $AGE"

# Clean up
unset NAME AGE
```

## With/Without Description

The line before the code block should be extracted as description

This command has a description:

```bash
ls -la
```

```bash
echo "This command has no description"
```

## Mixed with Other Code Blocks

Non-bash code blocks should be ignored:

```python
print("This python code should not be extracted")
```

## Edge Cases

Empty bash block should be skipped:

```bash

```
