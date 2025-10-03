# Lab1_comp
# Python Subset Lexical Analyzer (Flex)  
This project is a **lexical analyzer written in Flex** for a simplified subset of Python. It recognizes keywords, identifiers, literals, operators, and symbols, while reporting malformed tokens as **lexical errors** with line and column information.  

## Requirements  
Ubuntu with `flex` and `gcc` installed:  
```bash
sudo apt update && sudo apt install flex gcc
```

## Build
```bash
flex analizador(1).l (ignore warning)
gcc lex.yy.c -o analizador -lfl
```


## Run

```bash
./analizador [nombre de archivo].txt
```



## Example

### Input
```python
def eval(xi, exp):
    ans = False
    for i in range(len(exp)):
        part =? True
        for j in range(len(exp[i])):
            part = part and xi[exp[i][j]]
        ans=ans or part
    
    return ans
#comentario ignorado

while 2*i<=40000L
    h = 3.4e-5 + 5j
    if i == 0:
        break

def otra_fun():
    pass

print("Esta es la respuesta",con_123, "y la expresión ", 3*i+5*(7-x))

#string de la hipotesis
table = []
y = 123ABC
#i = 0

```

### output
```txt
DEF id1=eval parabre=( id2=xi coma=,  id3=exp parcierr=) dospunt=: 

    id4=ans  assign==  FALSE

    FOR id5=i  IN RANGEparabre=( id6=len parabre=( id3=exp parcierr=) parcierr=) dospunt=: 

        id7=part  assign== ERROR = ? TRUE

        FOR id8=j  IN RANGEparabre=( id6=len parabre=( id3=exp corabre=[ id5=i corcier=] parcierr=) parcierr=) dospunt=: 

            id7=part  assign==  id7=part  AND id2=xi corabre=[ id3=exp corabre=[ id5=i corcier=] corabre=[ id8=j corcier=] corcier=] 

        id4=ans assign== id4=ans  OR id7=part 

    

    RETURN id4=ans 





WHILE entero=2 mult=* id5=i menor_ig=<= long=40000L 

    id9=h  assign==  real=3.4e-5  suma=+  imaginario=5j 

    IF id5=i  comp===  entero=0 dospunt=: 

        BREAK



DEF id10=otra_fun parabre=( parcierr=) dospunt=: 

    PASS



PRINTparabre=( cadena="Esta es la respuesta" coma=, id11=con_123 coma=,  cadena="y la expresión " coma=,  entero=3 mult=* id5=i suma=+ entero=5 mult=* parabre=( entero=7 menos=- id12=x parcierr=) parcierr=) 





id13=table  assign==  corabre=[ corcier=] 

id14=y  assign==  ERROR = 123ABC





--- Identificadores encontrados ---
Id1=eval
Id2=xi
Id3=exp
Id4=ans
Id5=i
Id6=len
Id7=part
Id8=j
Id9=h
Id10=otra_fun
Id11=con_123
Id12=x
Id13=table
Id14=y

Total errores léxicos: 2


Total errores léxicos: 10
```
