# epitemplates

Centralises `Rmarkdown` and `Quarto` templates for EpiDS.
 
## Installation 

```
remotes::install_github("epicentre-msf/epitemplates")
```

## Usage

- **Rmarkdown**

Using RStudio IDE, `File > New File > R Markdown`. 

Click on the *From Templates* and select _Epicentre Rmd template_ from the pane

The templates could also be loaded by typing `rmarkdown::draft("epicentre-rmd")`
in the R console.

- **Quarto**

Create EpiDS book template with `epitemplates::epids_qmd(dir, project_type = "book")` where `dir` is the directory of the book. 
The book is based on quarto project
type [epicentre-msf/epitemplates-book](https://github.com/epicentre-msf/epitemplates-report).

For single documents, `epitemplates::epids_qmd(dir, project_type = "document")` where `dir` is the directory for the new document. Documents are based on templates from [epicentre-msf/epitemplates-report](https://github.com/epicentre-msf/epitemplates-report).

Alternatively on RStudio IDE, you can use the `addins` dropdown to create
a quarto document or a book folder (ex. `Addins > EpiDS quarto document`).




