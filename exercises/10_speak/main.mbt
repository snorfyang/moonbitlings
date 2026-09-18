///|
/// A trait for things that can make a sound.
pub trait Speak {
  speak(Self) -> String
}

///|
pub struct Dog {}

///|
pub struct Cat {}

///|
pub fn Dog::new() -> Dog {
  Dog::{}
}

///|
pub fn Cat::new() -> Cat {
  Cat::{}
}

///|
pub extend Dog with Speak::{
  speak,
}

///|
pub extend Cat with Speak::{
  speak,
}

///|
/// Make `Dog` say "woof".
impl Speak for Dog with fn speak(self) -> String {
  "TODO"
}

///|
/// Make `Cat` say "meow".
impl Speak for Cat with fn speak(self) -> String {
  "TODO"
}
