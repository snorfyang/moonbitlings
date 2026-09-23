///|
pub trait Speak {
  fn speak(Self) -> String
}

///|
pub struct Dog {}

///|
pub struct Cat {}

///|
pub fn Dog::new() -> Dog {
  Dog::{ }
}

///|
pub fn Cat::new() -> Cat {
  Cat::{ }
}

///|
pub extend Dog with Speak::{speak}

///|
pub extend Cat with Speak::{speak}

///|
impl Speak for Dog with fn speak(_self) -> String {
  "woof"
}

///|
impl Speak for Cat with fn speak(_self) -> String {
  "meow"
}
