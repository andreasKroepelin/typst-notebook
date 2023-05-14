#import "../template-notebook.typ": notebook

#set text(font: ("Inria Sans", "OpenMoji"))

#show: notebook.with(
  title: [My cool notebook],
  author: [My name],
  tags: (
    work: orange,
    family: aqua,
  )
)

= My first entry
This is a very important note about @work.
You can find more details in @fermat-s-1st-theorem.

@work

= Birthday party #emoji.party
TODO Don't forget to buy a present for grandma! #emoji.cake

TODO Write card.

DONE Organise cake.

@family

= Fermat's 1st theorem $a^p ident a med (mod p)$
This extends @my-first-entry by an interesting note about number theory.

TODO Read more about primes.
