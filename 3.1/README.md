#Task 3.1** 
Implement parser combinators in a programming language of your choice which supports higher-order functions. At least the following combinators must be implemented:

1. string or regex parser
1. sequence (a, b )
1. Kleene star
1. composition (a ∘ b: parse a, pass result to b; if b fails, whole composition fails)
1. lookahead (a | b : parse a, try parse b, if b succeeds, continue parsing from the last part of a)

#Задача 3.1**
Реализуйте комбинаторы синтаксического анализа на выбранном вами языке программирования, который поддерживает функции более высокого порядка. Должны быть реализованы, по крайней мере, следующие комбинаторы:

1. последовательность синтаксического анализатора строк или регулярных
1. выражений (a, b )
1. Композиция Kleene star
1. (a ∘ b: разбор a, передача результата в b; если b завершается неудачей, вся композиция завершается неудачей)
1. lookahead (a | b : разбор a, попробуйте разобрать b, если b завершится успешно, продолжите разбор с последней части a)
