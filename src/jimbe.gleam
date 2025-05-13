import gleam/list
import gleam/io

type OpType {
  Push(x: Int)
  Plus
  Dump
}

const program = [Dump, Push(35), Push(34), Plus, Dump]

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
      panic as "Not op in the stack arguments for the plus op"
    }
    [Dump, ..rest] if stack_len > 0 -> {
      io.println("Stack:")
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

pub fn main() {
  let stack = []
  let stack_len = list.length(stack)
  simulate_prog(program, stack, stack_len)
}
