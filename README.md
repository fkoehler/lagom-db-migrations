# Motivation

We wanted to migrate our production database via an external migration tool and also manually create the keyspaces and
tables for the Lagom Framework [https://www.lagomframework.com/]. For this one needs to know how the structure of the tables
are. Since there are multiple components in play this project wants to provide all full set of all migrations required
for Lagom to work.

It provides full exports and steps to migrate from one version to the next.

This project was started at Lagom version 1.4.0 so there are no prior migration steps available. PRs welcome.

# File structure:

- <lagom_version>-full.cql: Contains the complete dump for the version
- <lagom_version>-from-<lagom_version>.cql: Completes only those steps required to upgrade the version

# How to use

You probably want to have an external migration tool for C* like Pillar [https://github.com/Galeria-Kaufhof/pillar] to
execute your cql files with.

You should copy the cql files to your project and manually review them. Not all modules might apply to your system or
your naming might be different or you changed the compaction strategies or whatever.