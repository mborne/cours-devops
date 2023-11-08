# Diagramme de Gantt illustrant l'efficacité de l'exploitation traditionnelle

Illustration de l'effet des temps d'attente sur la durée d'un déploiement avec :

* 2 semaines d'attente de l'équipe OPS sur le premier déploiement (temps de découverte de l'application, autres applications à traiter,...)
* 1 semaine d'attente pour un nouveau déploiement après reprise de la documentation (autres applications à traiter)

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title       RETEX de la livraison v0.1.0
    excludes    weekends
    %% (`excludes` accepts specific dates in YYYY-MM-DD format, days of the week ("sunday") or "weekends", but not the word "weekdays".)

    section Côté DEV
    Tag v0.1.0                    :active,  dev1, 2022-05-02, 2h
    Déploiement en DEV            :active,  dev23-dev, after dev1, 2d
    Rédaction DAT                 :active,  dev2, after dev1, 1d
    Rédaction DEX                 :active,  dev3, after dev2, 1d
    Demande déploiement en QUALIF :active,  dev4, after dev3, 1d
    Attente déploiement en QUALIF :crit,    dev5, after dev4, 10d
    Recette en QUALIF             :active,  dev6, after dev5, 2d
    Correction des docs           :active,  dev7, after dev6, 1d
    Attente correction OPS        :crit,    dev8, after dev7, 6d
    Recette en QUALIF             :active,  dev9, after dev8, 2d
```

En complément, vous pourrez lire l'article [fr.kaizen.com - L'importance du Time to Market](https://kaizen.com/fr/publications/importance-time-to-market-fr/) qui aborde la notion d'**efficacité des flux** et des alternatives pour mettre en lumière l'effet des temps d'attente.
