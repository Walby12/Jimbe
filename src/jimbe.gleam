type OpType {
  Push(x: Int)
  Plus
  Dump
}

const program = [Push(32), Push(32), Plus, Dump]

fn simulate_prog(program:  List(OpType)) {
  case program {
    [Push(x), ..rest] -> {
      echo "Push"
      simulate_prog(rest)
    }

    [Plus, ..rest] -> {
      echo "Plus"
      
      simulate_prog(rest)
    }
    [Dump, ..rest] -> {
      echo "Dump"
      simulate_prog(rest)
    }
    [] -> echo "Done"
    
  }
}

fn compile_prog(program: #()) {
  echo "Not implemented"
}

pub fn main() {
  simulate_prog(program)
}
