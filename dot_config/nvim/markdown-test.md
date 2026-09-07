<!--toc:start-->
- [Header 1](#header-1)
- [H1](#h1)
  - [H2](#h2)
    - [H3](#h3)
      - [H4](#h4)
        - [H5](#h5)
          - [H6](#h6)
  - [Header 2](#header-2)
    - [Header 3](#header-3)
      - [Header 4](#header-4)
        - [Header 5](#header-5)
          - [Header 6](#header-6)
<!--toc:end-->

# Header 1


# H1
## H2
### H3
#### H4
##### H5
###### H6


## Header 2

- This is a test
- point 2
  - Item3
    - point 4
- item 3
  - long long long long long long long long long long long long long long long long long long long text  long text  long text  long text  long text  long text  long text  long text  long
  - medium text medium text medium text medium text medium text medium text medium text medium text medium text medium text medium text medium text
  - long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text
- item 3
  - item 3
  - item 3
- item 3
  - item 3
    - item 3
- item 3
  - item 3
  - item 3
1. point 2
  2. Item3
    3. point 4

render-markdown does not play nice with list markers other than \d\.
1. item 3
  2. long long long long long long long long long long long long long long long long long long long text  long text  long text  long text  long text  long text  long text  long text  long
  3. medium text medium text medium text medium text medium text medium text medium text medium text medium text medium text medium text medium text
  45. long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text


$$ \begin{bmatrix} 6&8&9 \\ 2&3&2 \end{bmatrix} $$

$$ \Sigma_{3} $$


| Column1 | Column2 | Column3 | Column4 | Column5 |
| --------------- | --------------- | --------------- | --------------- | --------------- |
| Item1.1 | Item2.1 | Item3.1 | Item4.1 | Item5.1 |
| Item1.2 | Item2.2 | Item3.2 | Item4.2 | Item5.2 |


### Header 3

> [!IMPORTANT]
> point to note!

```python
import numpy as np

a = np.array([1,2,3,4])

a.shape
```

---

```bash

echo $PATH
git diff

```


```markdown
hello
```


#### Header 4

* [ ] TODO
  * [x] buy chicken @done(10/02/25 16:13)
  * [ ] be happy
    * [ ] learn stuff @started(10/02/25 16:57)
  * [x] howdydody long text long text long text long text long text long text long text long text
  long text long text long text long text long text long text long text long text 
  * [ ] howdydody
    - [ ] howdydody @priority(high)
    - [ ] howdydody
  - [ ] howdydody
- [ ] item 2
- [ ] item3
- [ ] checkbox

- [ ] bada


##### Header 5

###### Header 6

```lua
function has(feature: string) -> (0|1)
```
──────────────────────────────────────────────────
Returns 1 if {feature} is supported, 0 otherwise.  The
{feature} argument is a feature name like "nvim-0.2.1" or
"win32", see below.  See also |exists()|.

To get the system name use |vim.uv|.os_uname() in Lua: >lua
  print(vim.uv.os_uname().sysname)

<If the code has a syntax error then Vimscript may skip the
rest of the line.  Put |:if| and |:endif| on separate lines to
avoid the syntax error: >vim
  if has('feature')
    let x = this_breaks_without_the_feature()
  endif
<
Vim's compile-time feature-names (prefixed with "+") are not
recognized because Nvim is always compiled with all possible
features. |feature-compile|

Feature names can be:
1.  Nvim version. For example the "nvim-0.2.1" feature means
    that Nvim is version 0.2.1 or later: >vim
  if has("nvim-0.2.1")
    " ...
  endif

<2.  Runtime condition or other pseudo-feature. For example the
    "win32" feature checks if the current system is Windows: >vim
  if has("win32")
    " ...
  endif
<          *feature-list*
    List of supported pseudo-feature names:
  acl    |ACL| support.
  *android*  Android system (not necessarily |termux|).
  bsd    BSD system (not macOS, use "mac" for that).
  clipboard  |clipboard| provider is available.
  fname_case  Case in file names matters (for Darwin and MS-Windows
      this is not present).
  gui_running  Nvim has a GUI.
  hurd    GNU/Hurd system.
  iconv    Can use |iconv()| for conversion.
  linux    Linux system.
  mac    MacOS system.
  nvim    This is Nvim.
  python3    Legacy Vim |python3| interface. |has-python|
  pythonx    Legacy Vim |python_x| interface. |has-pythonx|
  sun    SunOS system.
  *termux*  Termux, an |android| terminal app and packaging environment.
  ttyin    input is a terminal (tty).
  ttyout    output is a terminal (tty).
  unix    Unix system.
  *vim_starting*  True during |startup|.
  win32    Windows system (32 or 64 bit).
  win64    Windows system (64 bit).
  wsl    WSL (Windows Subsystem for Linux) system.

          *has-patch*
3.  Vim patch. For example the "patch123" feature means that
    Vim patch 123 at the current |v:version| was included: >vim
  if v:version > 602 || v:version == 602 && has("patch148")
    " ...
  endif

<4.  Vim version. For example the "patch-7.4.237" feature means
    that Nvim is Vim-compatible to version 7.4.237 or later. >vim
  if has("patch-7.4.237")
    " ...
  endif
<



What is Lorem Ipsum?

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since 1966, when designers at Letraset and James Mosley, the librarian at St Bride Printing Library in London, took a 1914 Cicero translation and scrambled it to make dummy text for Letraset's Body Type sheets. It has survived not only many decades, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised thanks to these sheets and more recently with desktop publishing software like Aldus PageMaker and Microsoft Word including versions of Lorem Ipsum.
Why do we use it?

It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).

Where does it come from?

Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

The standard chunk of Lorem Ipsum used since 1966 is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.

