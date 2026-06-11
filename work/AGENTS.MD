### Issues

This directory is dedicated to issues with the parent nix configuration.

Agents working in this folder have the following tasks :

1. Resolve issues.
2. Propose solutions.
3. Create patches.

### Structure

The root of this directory contains new issues.
./pending/ contains issues in progress.

### Methodology 

You will go over .md files in this directory with the "issue_" prefix. Each issue will describe a user's frustrations with the configration, request a feature or ask a question.

You will estimate the difficulty of resolving an issue, give it a label. \
Use the following flags - FEATURE_REQUEST MAJOR_CHANGE MINOR_CHANGE.

A FEATURE_REQUEST would require extra configuration files. - This would be adding a components like sops or keyd or docker to the configuration.
A MAJOR_CHANGE would break or replace existing functionality. An example would be being asked to enable autoscroll in a browser - that would generally break middle mouse paste. 
A MINOR_CHANGE would be minimally invasive. An example would be editing a theme or animation, adding a window rule, or making sure a theme applies to an application.

Create the Following directories and files : 
./pending/<issuedir>/issue.md <- move the original issue into this file.
./pending/<issuedir>/ <- issuedir is the same as the issue's filename without the extension. 
./pending/<issuedir>/status.txt 
./pending/<issuedir>/context.md <- enter relevant informaton about the issue and research so far.
./pending/<issuedir>/result/

In ./pending/<directory named the same as the .md file>/status.txt, enter the correct current status. Here's a table of possible statuses:



| STATUS    | MEANING |
| -------- | ------- |
| CONTINUE  | The user has updated files in the issue's directory and the agent may continue |
| IN_PROGRESS | An agent is currently working on this item |
| PROCESSED    | An Agent has completed this item and is awaiting for user input|
| ABORTED    | The user has cancelled this item. Do not touch. |

In ./pending/<issuedir>/context.md, 

This is now your workspace for this issue. Do NOT access any other issue's directory.


If there is enough data to implement a fix or provide a definitive answer, create the  directory and drop the results in there. 

If there is enough data to implement a fix or provide a definitive answer, you may create patches or shell script files that will be applied at a later time by the user, 
If there is enough data to implement a fix or provide a definitive answer, You may create RESEARCH.md documents that contain those results.
if there is insufficient data or further clarification is required to attempt a fix.You may create CLARIFICATIONS.md. 
You may NOT make permanent changes to the repository outside of the <git_root>/work/pending directory

Create patches only if they are trivial to create ( Guideline < 20 LoC), unless the file contains the string FORCE_ISSUE. Otherwise, summarize the necessary changes in a resarch.md.
