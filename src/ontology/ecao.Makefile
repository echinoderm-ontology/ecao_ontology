## Customize Makefile settings for ecao
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile


TEMPLATESDIR=../templates

TEMPLATES=$(patsubst %.tsv, $(TEMPLATESDIR)/%.owl, $(notdir $(wildcard $(TEMPLATESDIR)/*.tsv)))

prepare_templates: ../templates/config.txt
	sh ../scripts/download_templates.sh $<
	
components/all_templates.owl: $(TEMPLATES)
	$(ROBOT) merge $(patsubst %, -i %, $^) \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
		--output $@.tmp.owl && mv $@.tmp.owl $@

$(TEMPLATESDIR)/%.owl: $(TEMPLATESDIR)/%.tsv $(SRC)
	$(ROBOT) merge -i $(SRC) remove --select "<http://purl.obolibrary.org/obo/ECAO_*>" -o tmp/merged.owl
	$(ROBOT) template -i tmp/merged.owl --prefix "ECAO: http://purl.obolibrary.org/obo/ECAO_" --template $< --output $@ && \
	$(ROBOT) annotate --input $@ --ontology-iri $(ONTBASE)/components/$*.owl -o $@
