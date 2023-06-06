# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

doctors = Doctor.create([
                          { name: "Doctor one", address: "Address one, City1, State1", image_url: "doctor1.jpeg"},
                          { name: "Doctor two", address: "Address two, City2, State2", image_url: "doctor1.jpeg"},
                          { name: "Doctor three", address: "Address three, City3, State3", image_url: "doctor1.jpeg"},
                          { name: "Doctor four", address: "Address four, City4, State4", image_url: "doctor1.jpeg"}
                        ])