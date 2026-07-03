%% Sabancı University Thesis/Dissertation Class File
% S-  samet.apaydin@sabanciuniv.edu
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sabanci-template}[03/07/2026 v1.9 Sabanci Thesis/Dissertation Class]
\newcommand{\sabanciClassName}{03/07/2026 v1.9 Sabanci Thesis/Dissertation Class}
\newif\ifdevmode
\devmodefalse
%--------------------------------------------------------------------
% Class Options
%--------------------------------------------------------------------
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
%--------------------------------------------------------------------
% Base Class
%--------------------------------------------------------------------
\LoadClass[12pt, a4paper, oneside, leqno]{book}
%--------------------------------------------------------------------
% REQUIRED INFORMATION
%--------------------------------------------------------------------
\RequirePackage{xstring}
\RequirePackage{etoolbox}
%--------------------------------------------------------------------
% Degree to allow switch btw. Master - PhD
%--------------------------------------------------------------------
\newif\ifSU@phd
\SU@phdfalse
\newcommand{\degree}[1]{%
  \edef\SU@deg{#1}%
  \IfStrEq{\SU@deg}{}{%
    \ClassError{sabanci_template}{Missing degree. Allowed: Master, PhD}{Missing degree. Allowed: Master, PhD}%
  }{%
    \IfStrEq{\SU@deg}{Master}{\SU@phdfalse}{%
      \IfStrEq{\SU@deg}{PhD}{\SU@phdtrue}{%
        \ClassError{sabanci_template}{Invalid degree `#1'. Allowed: Master, PhD}{Invalid degree `#1'. Allowed: Master, PhD}%
      }%
    }%
  }%
}
\newcommand{\SUdegreeNameEN}{%
  \ifSU@phd
    Doctor of Philosophy%
  \else
    \ifSU@ens
      Master of Science%
    \else
      \ifSU@psychology Master of Science\else Master of Arts\fi
    \fi
  \fi
}

\newcommand{\SUworkTypeEN}{%
  \ifSU@phd
    Ph.D.\ Dissertation%
  \else
    \ifSU@ens
      M.Sc.\ Thesis%
    \else
      \ifSU@psychology M.Sc.\ Thesis\else M.A.\ Thesis\fi
    \fi
  \fi
}

\newcommand{\SUsupervisorLabelEN}{\ifSU@phd Dissertation Supervisor\else Thesis Supervisor\fi}
\newcommand{\SUtezTypeTR}{\ifSU@phd Doktora Tezi\else Yüksek Lisans Tezi\fi}
%--------------------------------------------------------------------
% Metafields for Student Informatıon
%--------------------------------------------------------------------
\newcommand{\DefineMetadataField}[2]{%
  \expandafter\def\csname default@#1\endcsname{#2}%
  \expandafter\newcommand\csname #1\endcsname[1]{%
    \expandafter\def\csname value@#1\endcsname{##1}%
    \ifdevmode\else
      \ifx\csname value@#1\endcsname\@empty
        \PackageError{sabanci_template}{Missing required field: #1}{Missing required field: #1. Define \string#1\string{...\string} in main.tex.}%
      \fi
      \edef\tempA{\csname value@#1\endcsname}%
      \edef\tempB{\csname default@#1\endcsname}%
      \ifx\tempA\tempB
        \PackageError{sabanci_template}{Default value not changed: #1}{Default value not changed: #1. Replace the placeholder text in \string#1\string{...\string}.}%
      \fi
    \fi
  }%
  \expandafter\newcommand\csname print#1\endcsname{%
    \ifx\csname value@#1\endcsname\@empty
      \csname default@#1\endcsname
    \else
      \csname value@#1\endcsname
    \fi
  }%
}
\DefineMetadataField{thesistitle}{Dissertation Title Dissertation Title}
\DefineMetadataField{tezbaslik}{Tez Basligi Tez Basligi Tez Basligi Tez Basligi}
\DefineMetadataField{authorname}{Author Name}
\DefineMetadataField{programnameTR}{Program Adi}
\newif\ifSU@psychology
\SU@psychologyfalse
\DefineMetadataField{programnameEN}{Program Name}
\let\SU@oldprogramnameEN\programnameEN
\renewcommand{\programnameEN}[1]{%
  \SU@oldprogramnameEN{#1}%
  \IfStrEq{#1}{Psychology}{%
    \global\SU@psychologytrue
  }{%
    \global\SU@psychologyfalse
  }%
}
%--------------------------------------------------------------------
% Comitte
%--------------------------------------------------------------------
\newif\ifSU@oktitle
\newcommand{\SU@isAllowedTitle}[1]{%
  \SU@oktitlefalse
  \IfStrEq{#1}{Prof.}{\SU@oktitletrue}{%
    \IfStrEq{#1}{Assoc. Prof.}{\SU@oktitletrue}{%
      \IfStrEq{#1}{Asst. Prof.}{\SU@oktitletrue}{}%
    }%
  }%
}
\newcommand{\SU@titleError}[1]{%
  \ClassError{sabanci_template}{Invalid title `#1'. Allowed titles: Prof., Assoc. Prof., Asst. Prof.}{Invalid title `#1'. Allowed titles: Prof., Assoc. Prof., Asst. Prof.}%
}
\def\SU@advisorTitle{}
\def\SU@advisorName{}
\def\SU@juryList{}
\newcounter{SU@juryCount}
\newcommand{\advisor}[2]{%
  \SU@isAllowedTitle{#1}%
  \ifSU@oktitle\else\ifdevmode\else\SU@titleError{#1}\fi\fi
  \gdef\SU@advisorTitle{#1}%
  \gdef\SU@advisorName{#2}%
}
\newcommand{\jurymember}[2]{%
  \SU@isAllowedTitle{#1}%
  \ifSU@oktitle\else\SU@titleError{#1}\fi
  \stepcounter{SU@juryCount}%
  \ifnum\value{SU@juryCount}>4\relax
    \ClassError{sabanci_template}{Too many jury members (max 5).}{Too many jury members (max 5). Use \string\jurymember\space at most 5 times.}%
  \fi
  \g@addto@macro\SU@juryList{\par\noindent\hspace*{1.25cm}#1\space \MakeUppercase{#2}\space \dotfill \\ \vspace{3\baselineskip}}%

}
\newcommand{\SU@checkcommittee}{%
  \begingroup
  \edef\tempA{\SU@advisorTitle}\edef\tempB{\SU@advisorName}%
  \ifx\tempA\@empty
    \ifdevmode\else
      \ClassError{sabanci_template}{Missing advisor.}{...}%
    \fi
  \fi
  \ifx\tempB\@empty
    \ClassError{sabanci_template}{Missing advisor.}{Missing advisor. Set \string\advisor\string{Title\string}\string{Name\string} in main.tex.}%
  \fi
  \ifnum\value{SU@juryCount}<1\relax
    \ClassError{sabanci_template}{Missing jury members.}{Missing jury members. Add at least 1 \string\jurymember\space in main.tex.}%
  \fi
  \endgroup
}
\newcommand{\SUprintsupervisor}{\SU@advisorTitle\space \MakeUppercase{\SU@advisorName}}%
\newcommand{\SUprintdanisman}{%
  \begingroup
  \edef\SU@trtitle{\SU@advisorTitle}%
  \IfStrEq{\SU@advisorTitle}{Prof.}{\edef\SU@trtitle{Prof.\ Dr.}}{}%
  \IfStrEq{\SU@advisorTitle}{Assoc. Prof.}{\edef\SU@trtitle{Doç.\ Dr.}}{}%
  \IfStrEq{\SU@advisorTitle}{Asst. Prof.}{\edef\SU@trtitle{Dr.\ Öğr.\ Üyesi}}{}%
  Tez Danışmanı: \SU@trtitle\space \MakeUppercase{\SU@advisorName}%
  \endgroup
}
\newcommand{\SUprintcommittee}{%
  \SU@checkcommittee
  \noindent\hspace*{1.25cm}\SU@advisorTitle\space \MakeUppercase{\SU@advisorName}\space \dotfill\\
  \noindent\hspace*{1.25cm}(\SUsupervisorLabelEN)%
  \ifSU@hascoadvisor
    \\[3.8\baselineskip]%
  \else
    \\[2\baselineskip]%
  \fi
  \SUprintoptionalcocommittee
  \SU@juryList
}
\def\SU@coadvisorTitle{}
\def\SU@coadvisorName{}
\newif\ifSU@hascoadvisor
\SU@hascoadvisorfalse

\newcommand{\coadvisor}[2]{%
  \ifblank{#1#2}{%
    \global\SU@hascoadvisorfalse
  }{%
    \SU@isAllowedTitle{#1}%
    \ifSU@oktitle\else\ifdevmode\else\SU@titleError{#1}\fi\fi
    \gdef\SU@coadvisorTitle{#1}%
    \gdef\SU@coadvisorName{#2}%
    \global\SU@hascoadvisortrue
  }%
}

\newcommand{\SUcosupervisorLabelEN}{\ifSU@phd Dissertation Co-Supervisor\else Thesis Co-Supervisor\fi}

\newcommand{\SUprintcosupervisor}{%
  \SU@coadvisorTitle\space \MakeUppercase{\SU@coadvisorName}%
}

\newcommand{\SUprintcodanisman}{%
  \begingroup
  \edef\SU@trtitle{\SU@coadvisorTitle}%
  \IfStrEq{\SU@coadvisorTitle}{Prof.}{\edef\SU@trtitle{Prof.\ Dr.}}{}%
  \IfStrEq{\SU@coadvisorTitle}{Assoc. Prof.}{\edef\SU@trtitle{Doç.\ Dr.}}{}%
  \IfStrEq{\SU@coadvisorTitle}{Asst. Prof.}{\edef\SU@trtitle{Dr.\ Öğr.\ Üyesi}}{}%
  İkinci Tez Danışmanı: \SU@trtitle\space \MakeUppercase{\SU@coadvisorName}%
  \endgroup
}

\newcommand{\SUprintoptionalcosupervisorEN}{%
  \ifSU@hascoadvisor
    \vspace{-2\baselineskip}%
    \SUcosupervisorLabelEN: \SUprintcosupervisor\\[1.5\baselineskip]
  \fi
}

\newcommand{\SUprintoptionalcodanismanTR}{%
  \ifSU@hascoadvisor
    \vspace{-2\baselineskip}%
    \SUprintcodanisman\\[1.5\baselineskip]
  \fi
}
\newcommand{\SUprintoptionalcocommittee}{%
  \ifSU@hascoadvisor
    \noindent\hspace*{1.25cm}\SU@coadvisorTitle\space \MakeUppercase{\SU@coadvisorName}\space \dotfill\\
    \noindent\hspace*{1.25cm}(\SUcosupervisorLabelEN)\\[2\baselineskip]
  \fi
}

\newcounter{SU@committeeCount}

\newcommand{\SU@updatecommitteecount}{%
  \setcounter{SU@committeeCount}{\value{SU@juryCount}}%
  \addtocounter{SU@committeeCount}{1}%
  \ifSU@hascoadvisor
    \addtocounter{SU@committeeCount}{1}%
  \fi
}
%--------------------------------------------------------------------
% institute Switch
%--------------------------------------------------------------------
\newif\ifSU@okinstitute
\newcommand{\SU@isAllowedinstitute}[1]{%
  \SU@okinstitutefalse
  \IfStrEq{#1}{Graduate School of Engineering and Natural Sciences}{\SU@okinstitutetrue}{%
    \IfStrEq{#1}{Graduate School of Social Sciences}{\SU@okinstitutetrue}{%
      \IfStrEq{#1}{Sabancı Graduate Business School}{\SU@okinstitutetrue}{}%
    }%
  }%
}
\newif\ifSU@ens
\SU@ensfalse
\newcommand{\SU@instituteError}[1]{%
  \ClassError{sabanci_template}{Invalid institute `#1'. Allowed faculties: Graduate School of Engineering and Natural Sciences, Graduate School of Social Sciences, Sabancı Graduate Business School}{Invalid institute `#1'. Allowed faculties: Graduate School of Engineering and Natural Sciences, Graduate School of Social Sciences, Sabancı Graduate Business School}%
}
\def\SU@institute{}
\newcommand{\institute}[1]{%
  \SU@isAllowedinstitute{#1}%
  \ifSU@okinstitute\else\ifdevmode\else\SU@instituteError{#1}\fi\fi
  \gdef\SU@institute{#1}%
  \IfStrEq{#1}{Graduate School of Engineering and Natural Sciences}{%
    \global\SU@enstrue
  }{%
    \global\SU@ensfalse
  }%
}
\newcommand{\printinstitute}{\SU@institute}
%--------------------------------------------------------------------
% Fonts
%--------------------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{mathptmx}
\RequirePackage{lmodern}
%--------------------------------------------------------------------
% Core Packages
%--------------------------------------------------------------------
\RequirePackage[english]{babel}
\RequirePackage{graphicx}
\RequirePackage{setspace}
\RequirePackage{import}
\RequirePackage{calc}
\RequirePackage{amsmath,amssymb,amsfonts,amsthm}
\RequirePackage{mathtools}
\RequirePackage{adjustbox}
\RequirePackage{floatrow}
\RequirePackage{tabularx}
\RequirePackage{mathrsfs}
\RequirePackage{pdflscape}
\RequirePackage{titlesec}
\RequirePackage{titlecaps}

\Addlcwords{a}
\Addlcwords{an}
\Addlcwords{the}
\Addlcwords{and}
\Addlcwords{as}
\Addlcwords{but}
\Addlcwords{for}
\Addlcwords{if}
\Addlcwords{nor}
\Addlcwords{or}
\Addlcwords{so}
\Addlcwords{yet}
\Addlcwords{at}
\Addlcwords{by}
\Addlcwords{in}
\Addlcwords{of}
\Addlcwords{off}
\Addlcwords{on}
\Addlcwords{per}
\Addlcwords{to}
\Addlcwords{up}
\Addlcwords{via}

\RequirePackage{multicol}
\RequirePackage{makeidx}
\RequirePackage{fancyhdr}
\RequirePackage{bm}
\RequirePackage{threeparttable}
\RequirePackage{rotating}
\RequirePackage{rotfloat}
\RequirePackage{silence}
\RequirePackage{csquotes}
\RequirePackage{xcolor}
\RequirePackage{colortbl}
\RequirePackage[flushmargin]{footmisc}
\RequirePackage{booktabs}
\RequirePackage{pdfpages}
\RequirePackage{array}
\RequirePackage{environ}
\RequirePackage[nogroupskip, toc, nonumberlist]{glossaries}
\makenoidxglossaries
\newglossary*{abbrev}{List of Abbreviations}
\newglossary*{symbols}{List of Symbols}
\InputIfFileExists{Abbreviations_Symbols/Abbreviations.tex}{}{}
\InputIfFileExists{Abbreviations_Symbols/Symbols.tex}{}{}
\WarningFilter{glossaries}{Empty glossary}

%--------------------------------------------------------------------
% Date/Time for Approval
%--------------------------------------------------------------------
\RequirePackage{datetime}
\renewcommand{\ordinaldate}[1]{#1}
\newdateformat{monthyeardate}{%
  \monthname[\THEMONTH]~\THEYEAR}
\newdateformat{monthdayyear}{%
  \monthname[\THEMONTH]~\THEDAY,~\THEYEAR}
\def\TRmonthname#1{\@TRmonthname{#1}}
\def\@TRmonthname#1{%
  \ifcase#1\relax
  \or Ocak\or Şubat\or Mart\or Nisan\or Mayıs\or Haziran%
  \or Temmuz\or Ağustos\or Eylül\or Ekim\or Kasım\or Aralık%
  \fi
}
\newdateformat{turkishmonthyear}{%
  \TRmonthname{\THEMONTH}~\THEYEAR
}
\newcount\SU@origyear
\newcount\SU@origmonth
\newcount\SU@origday
\AtBeginDocument{%
  \SU@origyear=\year
  \SU@origmonth=\month
  \SU@origday=\day
}
\newcommand{\approvaldate}[1]{%
  \edef\SUtmp{#1}%
  \ifblank{\SUtmp}{}{%
    \StrBefore{\SUtmp}{-}[\SUD]%
    \StrBehind{\SUtmp}{-}[\SUtmpB]%
    \StrBefore{\SUtmpB}{-}[\SUM]%
    \StrBehind{\SUtmpB}{-}[\SUY]%
    \ifblank{\SUM}{}{%
      \global\year=\SUY\relax
      \global\month=\SUM\relax
      \global\day=\SUD\relax
    }%
  }%
}
%--------------------------------------------------------------------
% Hyperref
%--------------------------------------------------------------------
\RequirePackage[pdftex,
            pdfproducer={\sabanciClassName},
            pdfcreator={\sabanciClassName},
            hyperfootnotes=false]{hyperref}
\hypersetup{
  colorlinks=true,
  citecolor=black,
  linkcolor=black,
  urlcolor=black,
}
\pdfstringdefDisableCommands{%
  \def\titlecap#1{#1}%
  \def\NoCaseChange#1{#1}%
  \def\uppercase#1{#1}%
}
\urlstyle{same}
\RequirePackage{geometry}
\geometry{
  left=3.5cm,
  right=2.5cm,
  top=2.5cm,
  bottom=2.5cm
}
\onehalfspacing
%--------------------------------------------------------------------
% Captions
%--------------------------------------------------------------------
\RequirePackage{caption}
\floatsetup{
  style=plain,
  valign=t}
\DeclareCaptionFormat{leftalign}{#1#2#3}
\captionsetup{
    format=leftalign,
    justification=raggedright,
    singlelinecheck=false,
    labelsep=space,
    margin=0pt,
    indention=0pt
}
\floatsetup[figure]{
    capposition=bottom,
    captionskip=.5\baselineskip
}
\floatsetup[table]{
    capposition=top,
    captionskip=.5\baselineskip
}
\DeclareCaptionLabelSeparator{none}{}
%--------------------------------------------------------------------
% Theorems
%--------------------------------------------------------------------
\newtheorem{theorem}{Theorem}[chapter]
\newtheorem{hypothesis}{Hypothesis}[chapter]
\newtheorem{proposition}{Proposition}[chapter]
\newtheorem{lemma}{Lemma}[chapter]
\newtheorem{claim}{Claim}[chapter]
\newtheorem{condition}{Condition}[chapter]
\newtheorem{case}{Case}[chapter]
\newtheorem{corollary}{Corollary}[chapter]
\newtheorem{remark}{Remark}[chapter]
\newtheorem{definition}{Definition}[chapter]
\newtheorem{example}{Example}[chapter]
\newtheorem{notation}{Notation}[chapter]
\theoremstyle{definition}
%--------------------------------------------------------------------
% Page Style
%--------------------------------------------------------------------
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyhf{}
\fancyfoot[C]{\thepage}
%--------------------------------------------------------------------
% Formats
%--------------------------------------------------------------------
\titleformat{\chapter}
  {\bfseries\normalsize\centering}
  {\thechapter.}
  {1ex}
  {\uppercase}
\titlespacing{\chapter}{1ex}{4\baselineskip}{3\baselineskip}
\titleformat{\section}
  {\bfseries\normalsize\centering}
  {\thesection}
  {1ex}
  {}
\titlespacing{\section}{1ex}{2\baselineskip}{2\baselineskip}
\titleformat{\subsection}
  {\bfseries\normalsize\raggedright}
  {\thesubsection}
  {1ex}
  {}
\titlespacing{\subsection}{1ex}{2\baselineskip}{\baselineskip}
\titleformat{\subsubsection}
  {\bfseries\normalsize\raggedright}
  {\thesubsubsection}
  {1ex}
  {\bfseries\normalsize}
\titlespacing{\subsubsection}{1ex}{2\baselineskip}{\baselineskip}
\titleformat{\part}[display]
  {\LARGE\centering}
  {\bf Part \thepart}
  {0em}
  {\hline \vspace{0.5cm} \bf}
\titlespacing{\part}
  {0pt}
  {0.5in}
  {2.0cm}
\let\oldsection\section
\def\section#1{\oldsection{\titlecap{#1}}}
\let\oldsubsection\subsection
\def\subsection#1{\oldsubsection{\titlecap{#1}}}



%--------------------------------------------------------------------
% TOC / LOF / LOT Labels
%--------------------------------------------------------------------
\addto\captionsenglish{\renewcommand{\contentsname}{\MakeUppercase{\bfseries Table of Contents}}}
\addto\captionsenglish{\renewcommand{\listtablename}{\bfseries LIST OF TABLES}}
\addto\captionsenglish{\renewcommand{\listfigurename}{\bfseries LIST OF FIGURES}}
\makeatletter
\renewcommand\l@figure[2]{%
  \begingroup
    \setstretch{1}%
    \setlength{\parskip}{0pt}%
    \parindent\z@
    \rightskip\@pnumwidth
    \parfillskip-\@pnumwidth
    \leavevmode
    #1\nobreak
    \leaders\hbox{\normalfont$\m@th\mkern \@dotsep mu\hbox{.}\mkern \@dotsep mu$}\hfill
    \hb@xt@\@pnumwidth{\hss #2}\par
    \vspace{0.5\baselineskip}%
  \endgroup
}
\renewcommand\l@table[2]{%
  \begingroup
    \setstretch{1}%
    \setlength{\parskip}{0pt}%
    \parindent\z@
    \rightskip\@pnumwidth
    \parfillskip-\@pnumwidth
    \leavevmode
    #1\nobreak
    \leaders\hbox{\normalfont$\m@th\mkern \@dotsep mu\hbox{.}\mkern \@dotsep mu$}\hfill
    \hb@xt@\@pnumwidth{\hss #2}\par
    \vspace{0.5\baselineskip}%
  \endgroup
}
\makeatother
\makeatletter
\pretocmd{\listoffigures}{\begingroup\let\addvspace\@gobble}{}{}
\apptocmd{\listoffigures}{\endgroup}{}{}
\pretocmd{\listoftables}{\begingroup\let\addvspace\@gobble}{}{}
\apptocmd{\listoftables}{\endgroup}{}{}
\makeatother
%--------------------------------------------------------------------
% TOC Chapter Entry Format
%--------------------------------------------------------------------
\makeatletter
\renewcommand{\numberline}[1]{#1.\hspace{0.5em}}
\patchcmd{\@dottedtocline}
  {\vskip \z@ \@plus.2\p@}
  {}
  {}{}
\renewcommand*\l@chapter[2]{
  \begingroup
    \setstretch{1}
    \setlength{\parskip}{0pt}
    \ifnum \c@tocdepth >\m@ne
      \addpenalty{-\@highpenalty}
      \setlength\@tempdima{1.5em}
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      \MakeUppercase{#1}\nobreak
      \leaders\hbox{\normalfont$\m@th\mkern \@dotsep mu\hbox{.}\mkern \@dotsep mu$}\hfill
      \hb@xt@\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \fi
    \vspace{0.5\baselineskip}
  \endgroup
}
\renewcommand*{\@dotsep}{1.25}
\renewcommand\l@section[2]{%
  \begingroup
    \setstretch{1}%
    \setlength{\parskip}{0pt}%
    \ifnum\c@tocdepth>0\relax
      \@dottedtocline{1}{1.5em}{2.3em}{#1}{#2}%
      \vspace{0.5\baselineskip}%
    \fi
  \endgroup
}
\renewcommand\l@subsection[2]{%
  \begingroup
    \setstretch{1}%
    \setlength{\parskip}{0pt}%
    \ifnum\c@tocdepth>1\relax
      \@dottedtocline{2}{3.8em}{3.2em}{#1}{#2}%
      \vspace{0.5\baselineskip}%
    \fi
  \endgroup
}
\renewcommand\l@subsubsection[2]{%
  \begingroup
    \setstretch{1}%
    \setlength{\parskip}{0pt}%
    \ifnum\c@tocdepth>2\relax
      \@dottedtocline{3}{7.0em}{4.1em}{#1}{#2}%
      \vspace{0.5\baselineskip}%
    \fi
  \endgroup
}
\makeatother
%--------------------------------------------------------------------
% Custom Environments
%--------------------------------------------------------------------
\newenvironment{tightcenter}{
  \setlength\topsep{0pt}
  \setlength\parskip{0pt}
  \begin{center}
}{
  \end{center}
}
%--------------------------------------------------------------------
% Paragraph spacing
%--------------------------------------------------------------------
\AtBeginDocument{
  \apptocmd{\normalsize}{
    \setlength{\parskip}{0.75\baselineskip}
    \setlength{\parindent}{0pt}
  }{}{}
}
%--------------------------------------------------------------------
% Counters
%--------------------------------------------------------------------
\setcounter{secnumdepth}{4}
\setcounter{tocdepth}{4}
%--------------------------------------------------------------------
% Footnotes
%--------------------------------------------------------------------
\setlength{\skip\footins}{12pt}
\setlength{\footnotesep}{12pt}
\makeatletter
\renewcommand\@makefnmark{%
  \hbox{\textsuperscript{\normalfont\fontsize{9pt}{9pt}\selectfont\@thefnmark}}%
}
\renewcommand{\@makefntext}[1]{%
  \begingroup
    \setstretch{1}%
    \setlength{\parskip}{0pt}%
    \noindent
    \hspace{2em}%
    {\normalfont\fontsize{9pt}{9pt}\selectfont\@thefnmark.}\ %
    #1%
  \endgroup
}
\makeatother
%--------------------------------------------------------------------
% Bibliography
%--------------------------------------------------------------------
\RequirePackage[style=apa, backend=biber, sortcites=true, natbib=true]{biblatex}
\DeclareLanguageMapping{english}{english-apa}
\addbibresource{Library.bib}
\AtBeginBibliography{
  \setstretch{1}
  \setlength{\bibitemsep}{0.5\baselineskip}
  \setlength{\bibparsep}{0pt}
}

%--------------------------------------------------------------------
% Quote
%--------------------------------------------------------------------
\makeatletter
\AtBeginEnvironment{quote}{%
  \singlespacing
}
\makeatother
\makeindex
\DeclarePairedDelimiter{\ceil}{\lceil}{\rceil}
\hbadness=10000
%--------------------------------------------------------------------
% Word Count for Abstract and Keywords
%--------------------------------------------------------------------
\newcommand{\wordcount}[1]{
  \StrCount{#1}{\space}[\tmp]
  \number\numexpr\tmp+1\relax
}
\newcounter{abstractwordcount}
\NewEnviron{checkedabstract}{
  \edef\abstracttemp{\BODY}
  \StrCount{\abstracttemp}{\space}[\tmp]
  \setcounter{abstractwordcount}{\numexpr\tmp+1}
  \typeout{*** ABSTRACT WORD COUNT = \theabstractwordcount\space ***}
\ifnum\value{abstractwordcount}>250
  \ClassError{sabanci_template}
    {Abstract exceeds 250-word limit (\theabstractwordcount\space words)}
    {The abstract is too long. Please shorten it to 250 words or fewer.}
\fi
  \BODY
}
\expandafter\def\csname SU@abstractEN\endcsname{}
\expandafter\def\csname SU@abstractTR\endcsname{}
\newcommand{\abstractEN}[1]{%
  \expandafter\gdef\csname SU@abstractEN\endcsname{#1}%
}
\newcommand{\abstractTR}[1]{%
  \expandafter\gdef\csname SU@abstractTR\endcsname{#1}%
}
\newcommand{\SUprintabstractEN}{\csname SU@abstractEN\endcsname}
\newcommand{\SUprintabstractTR}{\csname SU@abstractTR\endcsname}
\expandafter\def\csname SU@keywordsEN\endcsname{}
\expandafter\def\csname SU@keywordsTR\endcsname{}
\newcommand{\abstractkeywordsEN}[1]{%
  \StrCount{#1}{,}[\commacountEN]%
  \ifnum\commacountEN>4
     \ClassError{sabanci_template}
       {Too many EN keywords provided}
       {You may include a maximum of 5 keywords separated by commas.}
  \fi
  \expandafter\gdef\csname SU@keywordsEN\endcsname{#1}%
}
\newcommand{\abstractkeywordsTR}[1]{%
  \StrCount{#1}{,}[\commacountTR]%
  \ifnum\commacountTR>4
     \ClassError{sabanci_template}
       {Too many TR keywords provided}
       {You may include a maximum of 5 keywords separated by commas.}
  \fi
  \expandafter\gdef\csname SU@keywordsTR\endcsname{#1}%
}
\newcommand{\printkeywordsEN}{\csname SU@keywordsEN\endcsname}
\newcommand{\printkeywordsTR}{\csname SU@keywordsTR\endcsname}
%--------------------------------------------------------------------
%--------------------------------------------------------------------
\newif\ifSUfrontlistsdone
\SUfrontlistsdonefalse
\newcommand{\SUprintfrontlists}{%
  \ifSUfrontlistsdone\relax\else
    \SUfrontlistsdonetrue
    \clearpage
    \tableofcontents
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{\listtablename}%
    {\let\oldnumberline\numberline
     \renewcommand{\numberline}{\tablename~\oldnumberline}%
     \listoftables}%
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{\listfigurename}%
    {\let\oldnumberline\numberline
     \renewcommand{\numberline}{\figurename~\oldnumberline}%
     \listoffigures}%
    \clearpage
    \phantomsection
    {%
      \onehalfspacing
      \printnoidxglossary[type=symbols, title=\textbf{LIST OF SYMBOLS}]%
    }%
    \clearpage
    \phantomsection
    {%
      \onehalfspacing
      \printnoidxglossary[type=abbrev, title=\textbf{LIST OF ABBREVIATIONS}]%
    }%
  \fi
}
\pretocmd{\mainmatter}{\SUprintfrontlists}{}{}
\pretocmd{\mainmatter}{\onehalfspacing}{}{}
%--------------------------------------------------------------------

%--------------------------------------------------------------------
% FRONT MATTER
%--------------------------------------------------------------------

%--------------------------------------------------------------------
% Title page
%--------------------------------------------------------------------
\newcommand{\SUtitlepage}{%
  \thispagestyle{empty}%
  \begin{center}
    \MakeUppercase{\textbf{\printthesistitle}} \\[7\baselineskip]
    by \\
    \MakeUppercase{\printauthorname} \\[7\baselineskip]
    Submitted to the \printinstitute \\
    in partial fulfilment of \\
    the requirements for the degree of \SUdegreeNameEN \\
    in \printprogramnameEN \\[7\baselineskip]
    Sabancı University \\
    \monthyeardate\today
  \end{center}%
  \clearpage
}
%--------------------------------------------------------------------
% Information page
%--------------------------------------------------------------------
\makeatletter

\newcommand{\SUinformationpage}{%
  \SU@updatecommitteecount
  \clearpage\pagebreak
  \thispagestyle{empty}
  \onehalfspacing
  \begin{tightcenter}
    \MakeUppercase{\textbf{\printthesistitle}}
  \end{tightcenter}
  \vspace{3\baselineskip}
  \ifnum\value{SU@committeeCount}=5
    Approved by:\\[3\baselineskip]
  \else
    Approved by:\\[4\baselineskip]
  \fi
  \SUprintcommittee
  \ifnum\value{SU@committeeCount}=5
    \vspace{-0.5\baselineskip}
  \else
    \vspace{0.5\baselineskip}
  \fi

  Date of Approval: \monthdayyear\today
  \clearpage\pagebreak
  \thispagestyle{plain}
  \clearpage
  \thispagestyle{empty}
  \null\vfill
  \begin{center}
    \MakeUppercase{\printauthorname} \the\year\space $\copyright$ \\[\baselineskip]
    All Rights Reserved \\
  \end{center}
  \clearpage
}

\makeatother
%--------------------------------------------------------------------
% Abstract
%--------------------------------------------------------------------
\newcommand{\SUabstractEN}{%
  \setcounter{page}{4}%
  \chapter*{\vspace{-4\baselineskip}\bfseries ABSTRACT}%
  \addcontentsline{toc}{chapter}{ABSTRACT}
  \begin{center}
    \MakeUppercase{\printthesistitle}\\[3\baselineskip]
    \MakeUppercase{\printauthorname}\\[\baselineskip]
    \printprogramnameEN, \SUworkTypeEN, \monthyeardate\today\\[\baselineskip]
    \SUsupervisorLabelEN: \SUprintsupervisor\\[2\baselineskip]
    \SUprintoptionalcosupervisorEN
    Keywords: \printkeywordsEN\\[2\baselineskip]
  \end{center}
  \singlespacing
  \begin{checkedabstract}
    \SUprintabstractEN
  \end{checkedabstract}
  \clearpage\pagebreak
  \onehalfspacing
}
%--------------------------------------------------------------------
% Özet
%--------------------------------------------------------------------
\newcommand{\SUabstractTR}{%
  \chapter*{\vspace{-4\baselineskip}\bfseries ÖZET}%
  \addcontentsline{toc}{chapter}{ÖZET}
  \begin{center}
  \MakeUppercase{\printtezbaslik} \\[3\baselineskip]
  \MakeUppercase{\printauthorname} \\[\baselineskip]
  \printprogramnameTR, \SUtezTypeTR, \turkishmonthyear\today \\[\baselineskip]
  \SUprintdanisman \\[2\baselineskip]
  \SUprintoptionalcodanismanTR
  Anahtar Kelimeler: \printkeywordsTR\\[2\baselineskip]
  \end{center}
  \singlespacing
  \begin{checkedabstract}
    \SUprintabstractTR
  \end{checkedabstract}
  \clearpage\pagebreak
  \onehalfspacing
}
%--------------------------------------------------------------------
% Acknowledgements
%--------------------------------------------------------------------
\makeatletter
\def\SU@acknowledgement{}
\newcommand{\acknowledgement}[1]{%
  \long\gdef\SU@acknowledgement{#1}%
}
\newcommand{\SUprintacknowledgement}{\SU@acknowledgement}
\makeatother
\newcommand{\SUacknowledgement}{%
  \chapter*{\vspace{-4\baselineskip}\bfseries ACKNOWLEDGEMENTS}%
  \begingroup
    \setlength{\parindent}{0pt}%
    \SUprintacknowledgement
  \endgroup
}
%--------------------------------------------------------------------
% Dedication (optional)
%--------------------------------------------------------------------
\makeatletter
\newif\ifSU@hasdedication
\SU@hasdedicationfalse
\def\SU@dedication{}
\newcommand{\dedication}[1]{%
  \long\gdef\SU@dedication{#1}%
  \ifblank{#1}{%
    \global\SU@hasdedicationfalse
  }{%
    \global\SU@hasdedicationtrue
  }%
}
\newcommand{\SUdedication}{%
  \ifSU@hasdedication
    \clearpage
    \null\vfill
    \begin{flushright}
      \textit{\SU@dedication}%
    \end{flushright}
    \vfill\null
    \clearpage
  \fi
}
\makeatother
%--------------------------------------------------------------------
% Front Matter Order
%--------------------------------------------------------------------
\newcommand{\SUfrontmatter}{%
  \frontmatter
  \SUtitlepage
  \SUinformationpage
  \SUabstractEN
  \SUabstractTR
  \SUacknowledgement
  \SUdedication
}
%--------------------------------------------------------------------
% MAIN MATTER
%--------------------------------------------------------------------
\newcommand{\SUstartmain}{%
  \clearpage
  \mainmatter
  \onehalfspacing
}

%--------------------------------------------------------------------
% BIBLIOGRAPHY
%--------------------------------------------------------------------
\defbibheading{bibliography}[\bibname]{%
  \clearpage
  \phantomsection
  \begin{center}
    \vspace{-4.25\baselineskip}
    {\bfseries\centering \MakeUppercase{#1}}
    \vspace{\baselineskip}
  \end{center}
  \addcontentsline{toc}{chapter}{\MakeUppercase{#1}}%
}
\newcommand{\SUprintbibliography}{%
  \normalsize
  \printbibliography
  \clearpage
}
%--------------------------------------------------------------------
% APPENDIX
%--------------------------------------------------------------------
\makeatletter
\providecommand\SU@appTotal{0}
\newcounter{SU@appCount}
\let\SU@orig@chapter\chapter
\newcommand{\SU@appendixchapter}[1]{%
  \stepcounter{SU@appCount}%
  \refstepcounter{chapter}%
  \clearpage
  \begin{center}
    \vspace{-4.25\baselineskip}%
    \ifnum\SU@appTotal=1\relax
      {\bfseries APPENDIX\space-\space\uppercase{#1}\par}%
    \else
      {\bfseries APPENDIX \thechapter\space-\space\uppercase{#1}\par}%
    \fi
  \end{center}%
  \ifnum\SU@appTotal=1\relax
    \addcontentsline{toc}{chapter}{APPENDIX\space-\space\uppercase{#1}}%
  \else
    \addcontentsline{toc}{chapter}{APPENDIX \thechapter\space-\space\uppercase{#1}}%
  \fi
}
\g@addto@macro\appendix{%
  \setcounter{SU@appCount}{0}%
  \addtocontents{toc}{\protect\setcounter{tocdepth}{0}}%
  \setcounter{secnumdepth}{-1}%
  \captionsetup{list=no}%
  \let\chapter\SU@appendixchapter
}
\newcommand{\SUafterappendix}{%
  \addtocontents{toc}{\protect\setcounter{tocdepth}{4}}%
  \setcounter{secnumdepth}{4}%
  \captionsetup{list=yes}%
  \let\chapter\SU@orig@chapter
}
\AtEndDocument{%
  \immediate\write\@auxout{%
    \string\gdef\string\SU@appTotal{\arabic{SU@appCount}}%
  }%
}
\makeatother
\newcommand{\SUstartappendix}{%
  \onehalfspacing
  \appendix
}
%--------------------------------------------------------------------
% Just in case..
%--------------------------------------------------------------------
\AtBeginDocument{\sloppy}
\endinput
