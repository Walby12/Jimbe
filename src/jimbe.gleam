import gleam/list
import gleam/io
import argv

type OpType {
  Push(x: Int)
  Minus
  Plus
  Dump
}

const program = [Dump, Push(70), Push(1), Minus, Push(420), Dump]

fn add_to_stack(stack: List(Int), x: Int) -> List(Int) {
  [x, ..stack]
}

fn sum_list(stack: List(Int), sum: Int) -> Int {
  case stack {
    [head, ..rest] -> {
      let sum = sum + head
      sum_list(rest, sum)
    }
    [] -> {
      sum
    }  
  }
}

fn min_list(stack: List(Int), sum: Int) -> Int {
  case stack {
    [head, ..rest] -> {
      let sum = head - sum
      min_list(rest, sum)
    }
    [] -> {
      sum
    }  
  }
}

fn simulate_prog(program:  List(OpType), stack: List(Int), stack_len: Int) {
  case program {
    [Push(x), ..rest] -> {
      let stack = add_to_stack(stack, x)
      let stack_len = stack_len + 1
      simulate_prog(rest, stack, stack_len)
    }
    [Plus, ..rest] if stack_len >= 2 -> {
      let a = list.take(stack, 2)
      let sum = sum_list(a, 0)
      let new_stack = list.drop(stack, 2)
      let stack = add_to_stack(new_stack, sum)
      let stack_len = stack_len - 1
      simulate_prog(rest, stack, stack_len)
    }
    [Plus, ..] -> {
      panic as "Not enough ops in the stack for the plus op"
    }
    [Minus, ..rest] if stack_len >= 2 -> {
      let a = list.take(stack, 2)
      let sum = min_list(a, 0)
      let new_stack = list.drop(stack, 2)
      let stack = add_to_stack(new_stack, sum)
      let stack_len = stack_len - 1
      simulate_prog(rest, stack, stack_len)
    }
    [Minus, ..] -> {
      panic as "Not enough ops in the stack for the plus op"
    }
    [Dump, ..rest] if stack_len > 0 -> {
      // TODO: find another way
      echo stack
      simulate_prog(rest, stack, stack_len)
    }
    [Dump, ..rest] -> {
      io.println("Stack: [empty]")
      simulate_prog(rest, stack, stack_len)
    }
    [] ->  {
      io.println("Interpretation completed")
    }  
  }
}

fn usage() {
  io.println("Usage:")
  io.println("    int    [interprets the program]")
  io.println("    com    [compiles the program]")
  panic as "Provide a know arg"
}

pub fn main() {
  let stack = []
  let stack_len = list.length(stack)
  case argv.load().arguments {
    ["int"] -> {
      simulate_prog(program, stack, stack_len)
    }
    ["com"] -> {
      io.println("Not implemented")
    }
    _ -> {
      usage()
    }
  }
}
