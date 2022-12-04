use std::fs::File;
use std::io::{BufRead, self};

const INPUT: &str = "input.txt";



fn main() {
    part_a();
    part_b();
}

fn part_a() {
    let file = File::open(INPUT).expect("invalid input file");
    let lines = io::BufReader::new(file).lines();

    let mut best_val = i32::MIN;
    let mut best_idx = 0;

    let mut curr_val = 0;
    let mut curr_idx = 0;

    for l in lines.map(|l| l.unwrap()) {

        if l.is_empty() {
            println!("Elf: '{}' -> Cal: '{}'", curr_idx, curr_val);

            if curr_val > best_val {
                best_val = curr_val;
                best_idx = curr_idx;
            }

            curr_idx += 1;
            curr_val = 0;
        } else {
            let v = l.parse::<i32>().expect("failed to parse value");
            curr_val += v;
        }
    }

    if best_val < 0 {
        panic!("whoops something went wrong, best_val: '{}'", best_val);
    }


    println!("The most calories are carryed by the '{}' elf -> '{}' calories", (best_idx + 1), best_val);
}


// ----------------------------------------------


fn part_b() {
    let file = File::open(INPUT).expect("invalid input file");
    let lines = io::BufReader::new(file).lines();

    const ELF_COUNT: usize = 3;
    let mut best_vals:    [i32; ELF_COUNT]   = Default::default();

    let mut curr_val = 0;
    let mut curr_idx = 0;

    for l in lines.map(|l| l.unwrap()) {

        if l.is_empty() {
            println!("Elf: '{}' -> Cal: '{}'", curr_idx, curr_val);

            let _ = try_insert_val(&mut best_vals, curr_val);

            curr_idx += 1;
            curr_val = 0;
        } else {
            let v = l.parse::<i32>().expect("failed to parse value");
            curr_val += v;
        }
    }

    let sum: i32 = best_vals.iter().sum();

    if sum <= 0 {
        panic!("whoops something went wrong, sum: '{}'", sum);
    }

    println!("The top '{}' elfs are carying '{}' calories", ELF_COUNT, sum);
}

fn try_insert_val(best_vals: &mut [i32], curr_val: i32) -> Option<usize> {
    for (idx, &best_val) in best_vals.iter().enumerate() {

        if best_val < curr_val {
            best_vals[idx..].rotate_right(1);
            best_vals[idx] = curr_val;

            return Some(idx);
        }

    }

    None
}
