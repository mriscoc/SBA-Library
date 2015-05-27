# **vHDL Obfuscator GUI - Ofuscador de código HDL**
- - - 
![](toolbar.png)   

![](http://downloads.sourceforge.net/project/sbalibrary/toolbar.png?r=&ts=1432683642&use_mirror=ufpr)   

:::vhdl
signal TXDATi : std_logic_vector(DAT_O'Range);
alias  TXRDYi : std_logic is TXDATi(14);
signal RXDATi : std_logic_vector(DAT_I'Range);
alias  RXRDYi : std_logic is RXDATi(15);
:::

'''vhdl
signal TXDATi : std_logic_vector(DAT_O'Range);
alias  TXRDYi : std_logic is TXDATi(14);
signal RXDATi : std_logic_vector(DAT_I'Range);
alias  RXRDYi : std_logic is RXDATi(15);
'''

´´´vhdl
signal TXDATi : std_logic_vector(DAT_O'Range);
alias  TXRDYi : std_logic is TXDATi(14);
signal RXDATi : std_logic_vector(DAT_I'Range);
alias  RXRDYi : std_logic is RXDATi(15);
´´´

```vhdl
signal TXDATi : std_logic_vector(DAT_O'Range);
alias  TXRDYi : std_logic is TXDATi(14);
signal RXDATi : std_logic_vector(DAT_I'Range);
alias  RXRDYi : std_logic is RXDATi(15);
```

<script src="https://gist.github.com/mriscoc/1f89d34257605d542cef.js"></script>
