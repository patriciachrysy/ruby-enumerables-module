# Advance building blocks in Ruby

> Enumerable Module extension

Rewriting all the enumerables module's methods.

## Built With

- Ruby
- VSCode, Linters, Rubocop


## Getting Started

To get a local copy up and running follow these simple example steps.

- Clone the repository and there you go! ;-)

### Prerequisites

- Get ruby latest version installed

### Setup

- Clone the repository on your local machine
- cd into the folder, find the ibubble_sort.rb file an open it in code editor

### Install

- Install VSCode or any code editor you like
- Install Ruby(most recent version)
- Run this command on your terminal in order to install rubocop: gem install rubocop 

### Usage

### Run tests

- In the command line type `irb` command
- Then type `require ./enumerables.rb`
- Use the test these test cases in order to test each function and compare the result you get when testing with the original corresponding function
   * `[1,2,3].my_each{ |o| p o }` or `{one:1,two:2,three:3}.my_each{ |o, l| p l }`
   * `[1,2,3].my_each_with_index{ |o| p o }` or `{one:1,two:2,three:3}.my_each_with_index{ |o, l| p l }`
   * `[:foo, :bar].my_select { |x| x == :foo }`
   * `%w[ant bear cat].my_all?(/t/)`
   * `[1, 2i, 3.14].my_any?(Integer)`
   * `%w[ant bear cat].my_none? { |word| word.length ==5 }`
   * `[1,2,3,4,5].my_count{ |x| x%2==0 }`
   * `(1..4).my_map { |i| i*i }`
   * `(5..10).my_inject(:+)` or `(5..10).my_inject(1) { |product, n| product * n }` or `%w{ cat sheep bear }.my_inject {|memo, word| memo.length > word.length ? memo : word }`
   * `multiply_els([1,2,3])`


## Author

👤 **Manezeu Patricia Chrystelle**

- Github: [@githubhandle](https://github.com/patriciachrysy)
- Twitter: [@twitterhandle](https://twitter.com/ManezeuP)
- Linkedin: [linkedin](https://www.linkedin.com/in/manezeu-patricia-chrystelle-095072118/)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page]().

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

- Hat tip to anyone whose code was used
- Inspiration
- etc

## 📝 License

