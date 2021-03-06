require 'sinatra'
require 'sinatra/reloader' if development?

def cipher(string, shift)
  characters = string.chars # makes an array of the characters used
  # using % you limit the shift to under 26 which is the letter range from a-z, A-Z for examaple, both a shift of 1 and a shift of 27 would == 1
  wrapper = ->(char, a_A) { (a_A + (char.ord - a_A + (shift % 26)) % 26).chr } # When it reaches z it wraps around and continues with a
  encripted = []
  characters.each do |char| 
    if char =~ /[A-Z]/ # to encript only letters
      cripted = wrapper[char, 65] # 65 and 97 are the ASCII values for A and a respectively
    elsif char =~ /[a-z]/
      cripted = wrapper[char, 97]
    else      
      cripted = char
    end
    encripted << cripted
  end
  encripted.join
end

def convert(string, shift)
  if params['method'] == 'encript'
    cipher(string, shift)
  elsif params['method'] == 'decript'
    cipher(string, -shift)
  end
end

get '/' do
  message = convert(params['encript'], params['key'].to_i)
  erb :index, :locals => { message: message }
end