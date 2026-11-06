# Example contract

```
Contract: create-bookmark (seam: POST /bookmarks)

when a bookmark submission arrives
  while the requester is authenticated
    if the submitted URL is valid
      then the bookmark is stored for that requester
      and the stored bookmark is returned with its id
    if the submitted URL is invalid
      then the submission is rejected with a validation error
      and nothing is stored
    if the requester already saved this URL
      then the existing bookmark is returned
      and no duplicate is stored
  while the requester is not authenticated
    then the submission is rejected as unauthorised
    and nothing is stored

Non-goals: tagging, folders, link-preview fetching
```

Why this is a good contract:
- Every leaf is something a test can assert through the endpoint.
- Failure paths (invalid URL, duplicate, unauthenticated) are first-class.
- No mention of database tables, validators, or frameworks.
- Non-goals fence off tempting extras.
