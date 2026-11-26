![version](https://img.shields.io/badge/version-21%20R5%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)

# HDI_Embeddings

Generate and search AI embedding vectors on 4D entities with the 4D Embedding
Studio component. Originally published by 4D as a **HDI** (*How Do I*) example
for **4D 21 R5**; restored so it runs on current 4D releases.

## What it demonstrates

- Declaring an embedding definition on an entity attribute (`Settings/embeddings.json`):
  the model alias, the phrase template that turns a record into text, and
  `autoInvalidate` so vectors are marked dirty when the source text changes.
- Generating vectors in batch with the Embedding Studio pipeline
  (`cs.EmbeddingStudio.Process`), for dirty records only or for all records.
- Searching by similarity: the query text is embedded with the same model and
  compared against the stored vectors with a single ORDA query
  (`ds.Students.query("student_vector > :1"; {vector; threshold})`).
- Showing which rows are out of date: a `metaSource` method paints a row red
  while `student_vector_dirty` is true.
- A complete, localised demo UI (English and Japanese): XLIFF resources,
  per-language HTML help pages and per-language sample data.

## Key commands

| Command | Used for |
|---|---|
| `cs.EmbeddingStudio.Process.process()` | batch-generates vectors for the Students table |
| `cs.EmbeddingStudio.StudioEmbedder.embed()` | embeds the free-text query before the similarity search |
| `ds.Students.query("student_vector > :1"; ...)` | similarity search: one ORDA query over the vector index |
| `Localized string()` | resolves `:xliff:` ids at runtime (menus, labels, alerts, tooltips) |
| `Localized document path()` | locates `Resources/<lang>.lproj/` documents (help pages, sample data) |
| `SET DATABASE LOCALIZATION()` | follows the OS language (English or Japanese) at startup |
| `CALL WORKER(1; ...)` | opens the demo window in the application process without blocking |

## Requirements

- 4D 21 R5 or a later **feature release** (the project declares
  `compatibilityVersion` 2150). The 21.x LTS line (e.g. 21.2 LTS) is *not*
  sufficient: the Embedding Studio component declares a minimum version of
  21 R5 and 4D refuses to load it there ("current application version is too
  low"), even though the project itself opens.
- The components `4d/4D-AIKit` and `4d/4D-Embedding-Studio`, resolved through
  `Project/dependencies.json` on first open (network access required for the
  download; `tool4d` headless runs do not download dependencies — stage them
  in `Components/` yourself, see `.agents/skills/4dproject/references/dependencies.md`).
- An API key for an AI provider supporting embedding models (e.g. OpenAI
  `text-embedding-3-large`). `Project/Sources/AIProviders.json` ships the
  provider endpoint and model aliases but no key: open **4D Settings > AI**
  and configure your provider and API key before running the demo.

## Getting started

- Clone or download this repository and open the project via
  **File > Open Project** in 4D.
- Configure your AI provider and API key under **4D Settings > AI** before
  running the demo.
- Navigate to the "Mode/Return to design mode" menu to view the code.

## How it works

`Project/Sources/DatabaseMethods/onStartup.4dm` makes the UI language follow
the OS language, then calls `00_Start`. The start method opens the single demo
form `HDI2` non-blockingly (`DIALOG(...; *)` in the application process via
`CALL WORKER`); running it again brings the existing window to the front.

`HDI2` is a tab form with six pages: Overview, Configure AI settings,
Configure Embeddings, Generate Embeddings, Update Records and Search
Embeddings. The help text of each page is stored in the INFO table and loaded
by `InitInfo` from `Resources/<lang>.lproj/info<N>.html`, so the help follows
the UI language too. `PopulateStudents` creates eight sample students from
`Resources/<lang>.lproj/sampleData.json` when the table is empty; the
**Regenerate sample data** button drops them and recreates them in the current
UI language.

The interesting part is the search: `SearchStudents.4dm` embeds the query text
with the same model as the stored vectors, then keeps the students whose
`student_vector` is above the threshold, ordered by similarity. A sample-query
dropdown fills the field and runs the search in one click. The red rows in the
lists come from the `Decorate` method used as the list boxes' `metaSource`.

## Points of interest

- The vector column carries a **vector index** (`type="20"` in the catalog);
  the leftover B-tree index on the same column was removed -- a B-tree on a
  vector BLOB serves nothing.
- `Settings/embeddings.json` is committed deliberately: it is the demo's
  configuration, not user state.
- The phrase template is English ("Student {firstName} {lastName}, studying
  {program}. {bio}") even for the Japanese sample data. The multilingual
  embedding model handles the mix; localising the phrase would mean switching
  definitions per language, which the demo does not do.
- Data and UI language are independent: the shipped data file contains the
  English sample students, and the Japanese data appears when the UI language
  is Japanese on an empty table or after **Regenerate sample data**.
- The splash form of the original HDI was removed; the demo opens directly.

## Modernisation notes

Each branch represents a distinct modernisation effort, guided by a 4D skill.

| Branch | Description | Guidance |
|--------|-------------|----------|
| [`localise-ja`](../../tree/localise-ja) | English/Japanese XLIFF resources, HTML help pages, localised alerts and reports | [`4dlocalise`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dlocalise) |
| [`polish-ui`](../../tree/polish-ui) | dark mode, Liquid Glass button heights, stylesheet split | [`4dcss`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dcss) |
| [`demo-japan`](../../tree/demo-japan) | per-language sample data, sample-query dropdown, regenerate button | [`demo-sample-data`](https://github.com/miyako/skills/tree/main/4d-skills/skills/demo-sample-data) |
| [`shareable-repo`](../../tree/shareable-repo) | `compatibilityVersion`, startup pattern, agent setup, verified 4D version requirement (21 R5+ feature release; 21.x LTS cannot load the components) | [`4dstartup`](https://github.com/miyako/skills/tree/main/4d-skills/skills/4dstartup) |

## References

- [4D blog](https://blog.4d.com/)
- [4D documentation: Embeddings](https://developer.4d.com/docs/)
- Index of v16/v17 HDIs: [miyako/4d-hdi](https://github.com/miyako/4d-hdi)

## Screenshots

<img alt="Embedding Studio" src="Resources/Images/studio.png" width="600">
<img alt="AI provider settings" src="Resources/Images/provider.png" width="600">
<img alt="Students table" src="Resources/Images/table.png" width="600">
<img alt="Model alias" src="Resources/Images/modelAlias.png" width="600">
