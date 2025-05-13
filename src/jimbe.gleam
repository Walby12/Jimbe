import gleam/list
import gleam/io

type OpType {
  Push(x: Int)
  Plus
  Dump
}

const program = [Push(32), Push(32), Plus, Dump]

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
      echo "Push"
      let stack = add_to_stack(stack, x)
      let stack_len = stack_len + 1
      simulate_prog(rest, stack, stack_len)
    }

    [Plus, ..rest] if stack_len >= 2 -> {
      echo "Plus"
      
      let a = list.take(stack, 2)

      let sum = sum_list(a, 0)
      
      let new_stack = list.drop(stack, 2)

      let stack = add_to_stack(new_stack, sum)

      simulate_prog(rest, stack, stack_len)
    }
    [Plus, ..rest] -> {
      panic as "Not op in the stack arguments for the plus op"
    }
    [Dump, ..rest] -> {
      echo "Dump"
      simulate_prog(rest, stack, stack_len)
    }
    [] -> echo "Done"
    
  }
}

fn compile_prog(program: #()) {
  echo "Not implemented"
}

pub fn main() {
  let stack = []
  let stack_len = list.length(stack)
  simulate_prog(program, stack, stack_len)
}
