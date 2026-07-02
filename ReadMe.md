# Sabancı University Thesis/Dissertation Template  
## 0. Version Information and Credit

**Template Version:** v1.5
**Date:** May 2026

The updated Sabancı University Master’s Thesis and MA Dissertation templates were prepared and maintained by **Samet Apaydın**.

Earlier versions were originally created by **Mert Moral (2019)**, and later revised by **Mehmet Barlo (June 2019)** to enhance mathematical formatting and structure.

For questions, suggestions, or issues, please contact: **samet.apaydin@sabanciuniv.edu**

**Copyright © 2026, Sabancı University.**

This template is provided for academic use. Official formatting rules always supersede the template; students are responsible for ensuring compliance with their Graduate School’s current guidelines.

---------------------------------------------------------------------

## 1. Folder Structure

sabanci_main.tex
sabanci-template.cls
Library.bib

Abbreviations_Symbols/
    Abbreviations.tex
    Symbols.tex

Chapters/
    Chapter_1/
        Chapter/
            Chapter1.tex
        Appendix/
            Appendix1.tex
    Chapter_2/
        Chapter/
            Chapter2.tex
        Appendix/
            Appendix2.tex
ReadMe.md

---------------------------------------------------------------------

## 2. Required Thesis Metadata

Users **must** fill the following fields inside `sabanci_main.tex`:

\thesistitle{...}
\tezbaslik{...}
\authorname{...}
\programname{...}
\programad{...}
\degree{...}
\institute{...}
\approvaldate{...}
\advisor{...}{...}
\jurymember{...}{...}
\abstractkeywordsEN{...}
\abstractkeywordsTR{...}
\abstractEN{...}
\abstractTR{...}
\acknowledgement{...}
\dedication{...} % may be left empty

**Rules:**
- None of these fields may be empty, except `\dedication`.
- They cannot remain equal to the default placeholders.  
- If incorrect, **compilation will stop** with an error message.
IMPORTANT: If your name or `\tezbaslik` contains the Turkish lowercase letter `i`, write it as `{İ}` inside `\tezbaslik` and `\authorname`. Otherwise, LaTeX converts it to the English capital `I`.

All other Turkish characters (`ç`, `ğ`, `ö`, `ş`, `ü`) are capitalized correctly automatically.

Example: **\tezbaslik{Türk{İ}ye}** will produce "TÜRKİYE" whereas **\tezbaslik{Türkiye}** will produce "TÜRKIYE".

---------------------------------------------------------------------

## 3. Adding Information

It is strongly recommended **not to modify** `sabanci-template.cls`.
Changing class file internals may break formatting or cause non-compliance with the Graduate School Handbook.

Users should instead edit the following:

### **sabanci_main.tex**
- The main file that compiles the entire dissertation.
- Fill required metadata here; it will automatically create the Title Page, Abstract, Özet, and Information pages.

- **Abbreviations.tex and Symbols.tex** → See Section 7.

### Adding Additional Chapters
You may freely create new chapter files.

Example:
\import{"Chapters/Chapter_3/Chapter/"}{Chapter3}

You may also ignore the folder structure and store files differently if you prefer.  

Example:

\import{"Chapters/Chapter_2/"}{Ch3}

Or you can directly start new chapter via \chapter{} in `Chapter2.tex`

The default file structure is purely for an organization.

The template takes care of numbering and formatting automatically.

---------------------------------------------------------------------

## 4. Abstract and Özet (250-Word Limit)

The class automatically:
• Counts words  
• Enforces a 250-word maximum  
• Stops compilation if the limit is exceeded  

According to YÖK regulations, both the English abstract and the Turkish özet are limited to 250 words.

---------------------------------------------------------------------

## 5. Keywords (English and Turkish)

Rules:
• Maximum of 5 keywords (i.e., 4 commas)  
• Exceeding the limit triggers a class error  

YÖK regulations also limit both English and Turkish keywords to a maximum of five.

---------------------------------------------------------------------

## 6. Bibliography

The template uses APA 7 reference formatting.

In-text citations use natbib syntax:

\citet{Key} → Textual citation  
\citep{Key} → Parenthetical citation  
\citeauthor{Key} → Author name only  
\citeyear{Key} → Year only  

The entries are stored in Library.bib. If you change the file name it will not compile!

---------------------------------------------------------------------

## 7. Abbreviations and Symbols (Glossary)

Abbreviations and symbols are defined in:
Abbreviations_Symbols/Abbreviations.tex
Abbreviations_Symbols/Symbols.tex

Example entries:
\newglossaryentry{chr}{name=CHR, description={Commission on Human Rights}}

\newglossaryentry{sigma}{
  name={\ensuremath{\pmb{\sigma}}},
  text={\ensuremath{\sigma}},
  description={Standard deviation},
  sort={sigma},
  type=symbols
}

Use in text:
\gls{chr}
\gls{sigma}

or add \glsaddall once anywhere in the text, this will automatically print all gls{} entries in both Abbreviations and Symbols.

The List of Abbreviations and Symbols prints automatically after the List of Figures.

If no abbreviations exist, leave `Abbreviations.tex` empty.
If no symbols exist, leave `Symbols.tex` empty.

LaTeX will skip empty glossaries and may display the harmless warning:

"Empty glossary for \printnoidxglossary[type={main}]..."

---------------------------------------------------------------------

## 8. Figure and Table Captions

The template enforces:
• Table captions appear above tables  
• Figure captions appear below figures  

Figure captions remain below figures even if the user writes \caption before \includegraphics. 

---------------------------------------------------------------------
