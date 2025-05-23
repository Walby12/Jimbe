import gleam/list
import gleam/io
import gleam/int
import gleam/string
import argv
import simplifile

type OpType {
  Push(x: Int)
  Minus
  Plus
  Dump
}

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

fn split_string(file_path: String) -> List(String) {
  let content  = simplifile.read(from: file_path)
  let value =
  case content {
    Ok(inner) -> inner
    Error(_) -> panic as "ERROR: coud not open file"
  }
  let content = string.split(value, on: "\n")
  let value = string.concat(content)
  let content = string.split(value, on: " ")
  echo content
  content
}

fn report_err(statement: Int, index: Int) {
  let report = "ERROR: invalid op found in src at stmt: " <> int.to_string(statement) <> " at index: " <> int.to_string(index)
  panic as report
}

fn load_program_from_mem(content: List(String)) -> List(OpType) {
  load_program_from_mem_helper(content, [], 0, 0)
}

fn load_program_from_mem_helper(content: List(String), acc: List(OpType), statement: Int, index: Int) -> List(OpType) {
  case content {
    [".", ..rest] -> {
      let index = index + 1
      load_program_from_mem_helper(rest, [Dump, ..acc],statement, index)
    } 
      

    ["+", ..rest] -> {
      let index = index + 1
      load_program_from_mem_helper(rest, [Plus, ..acc], statement, index)
    }

    ["-", ..rest] -> {
      let index = index + 1
      load_program_from_mem_helper(rest, [Minus, ..acc], statement, index)
    }

    ["@", ..rest] -> {
      let statement = statement + 1
      let index = 0
      load_program_from_mem_helper(rest, acc, statement, index)
    }

    [head, ..rest] -> {
      let parsed = int.base_parse(head, 10)
      let index = index + 1
      let value =
      case parsed {
        Ok(inner) -> inner
        Error(_) -> report_err(statement, index)
      }
      load_program_from_mem_helper(rest, [Push(value), ..acc], statement, index)
    }

    [] -> {
      list.reverse(acc)
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
      panic as "ERROR: Not enough ops in the stack for the plus op"
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
      panic as "ERROR: Not enough ops in the stack for the minus op"
    }
    [Dump, ..rest] if stack_len > 0 -> {
      // TODO: find another way
      echo stack
      simulate_prog(rest, stack, stack_len)
    }
    [Dump, ..rest] -> {
      echo stack
      simulate_prog(rest, stack, stack_len)
    }
    [] ->  {
      io.println("Interpretation completed")
    }  
  }
}

fn usage() {
  io.println("Usage:")
  io.println("    <filename>    [interprets the program]")
}

pub fn main() {
  let stack = []
  case argv.load().arguments {
    [name, ..] -> {
      case name {
        "-h" -> {
          usage()
          io.println("Hope this helps")
        }
        _ -> {
          let content = split_string(name)
          let program = load_program_from_mem(content)
          simulate_prog(program, stack, 0)
        }
      }
    }
    [] -> {
      usage()
      io.println("Try Jimbe")
    }
  }
}
