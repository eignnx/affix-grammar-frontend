-- Hi! Welcome to Affix Grammar!

-- Lets generate a simple sentence that has a few variations. An example of the
-- kind of sentence we'll generate is:
--   "Last Wednesday, Val went for a walk in the park after supper."

-- We'll define a "rule" called `start`. This will be the starting point for
-- generating our sentences.

rule start = "Last Wednesday," character "went for a walk in" place "after supper."

-- We need to define two more rules, `character` and `place`.

rule character = "Sam" | "Val" | "Penny"

-- The character rule produces either Sam, Val, or Penny. Each of these three
-- are called "alternatives".

-- Now lets define the `place` rule.
rule place
    = "the woods"
    | "an abandoned parking lot"
    | "the park"
    | "the graveyard behind" place

-- This time we split each alternative onto separate lines. You can do this any
-- time you feel it makes things more readable.

-- Also, notice that the last alternative of the `place` rule references
-- itself. This is fine, as long as there is at least one (1)
-- non-self-referential alternatives as well.

-- Ok! We've defined everything we need. Now press the `Generate` button to see
-- the sentences that are generated!