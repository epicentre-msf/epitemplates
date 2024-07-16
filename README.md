# epitemplates

Centralises `Rmarkdown` and `Quarto` templates for EpiDS.
 
## Installation 

```r
remotes::install_github("epicentre-msf/epitemplates")
```

## Usage

- **Rmarkdown**

Using RStudio IDE, `File > New File > R Markdown`. 

Click on the *From Templates* and select _Epicentre Rmd template_ from the pane

The templates could also be loaded by typing

```r
epitemplates::epi_rmd(path)
```
In the R console where `path` is the path to your new Rmarkdown document.

Alternatively on RStudio IDE, you can use the `addins` dropdown to create
a Rmarkdown document (ex. `Addins > Epitemplates > Rmarkdown document`).

- **Quarto**

Create EpiDS book template with 

```r
epitemplates::epi_qmd(path, project_type = "book")
```

where `path` is the file path of the book. 
The book is based on quarto project
type [epicentre-msf/epitemplates-book](https://github.com/epicentre-msf/epitemplates-book).

For single documents, 

```r
epitemplates::epi_qmd(path)
```

where `path` is the directory for the new document. Documents are based on 
templates from [epicentre-msf/epitemplates-report](https://github.com/epicentre-msf/epitemplates-report).

Alternatively on RStudio IDE, you can use the `addins` dropdown to create
a quarto document or a book folder (ex. `Addins > Epitemplates > Quarto document`).




