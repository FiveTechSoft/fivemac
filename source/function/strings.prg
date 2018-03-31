// FWH strings multiple languages support

#include "Fivemac.ch"

static nLanguage := 0   // Initially will be set by LanguageID() function
// 1 English, 2 Spanish, 3 French, 4 Portugese, 5 German, 6 Italian

static aStrings := { ;
{ "Attention", "Atención", "Attention", "Atenção", "Achtung", "Attenzione" }, ;
{ "PDF Plugin Error", "Error del plugin de PDF", "Erreur de plugin du PDF", "Erro do plugin do PDF", ;
"PDF Plugin-Fehler", "Errore del plugin PDF" }, ;
{ "PDF not saved to send Email", "No se ha guardado el PDF a enviar por Email", ;
"PDF Non enregistré pour envoi Email", "PDF não foi salvo para mandar por email", ;
"PDF nicht gespeichert um E-Mail zu senden", "PDF non salvato per inviare e-mail" }, ;
{ "MS Word not installed", "MS Word no está instalado", "MS Word non installé", "MS Word não está instalado", ;
"MS Word ist nicht installiert", "MS Word non è installato" }, ;
{ "Failed to Create Word Document", "No se ha podido crear el documento de Word", ;
"Echec à la création du document Word", "Não foi possível criar o documento do Word", ;
"Fehler beim Erstellen des Word-Dokuments", "Impossibile creare il documento di Word" }, ;
{ "There is no output for export", "No hay nada que exportar", "Rien à exporter", "Nada para exportar", ;
"Nichts zu exportiren", "Non vi è alcuna uscita per l'esportazione" }, ;
{ "No .Doc file manipulation software installed", "No hay instalado software para usar ficheros .Doc", ;
"Pas de programme installé pour manipuler les fichiers .Doc", "Não há software instalado para usar arquivos .Doc", ;
"Keine .doc Bearbeitungssoftware installiert", ;
"Nessun installato. Software di manipolazione di file Doc" }, ;
{ "not found, imposible to continue", "no se ha encontrado, no se puede continuar", ;
"Pas trouvé, impossible de continuer", "não encontrado, impossível continuar", "nicht gefunden! Kann nicht fortsetzen", ;
"Non trovata. Impossible continuare" }, ;
{ "Printing Error", "Error de impresión", "Erreur impressión", "Erro de impressão", "Fehler beim Drucken", "Errore di stampa" }, ;
{ "View", "Visualizar", "Visualiser", "Visualizar", "Sehen Sie", "Visualizza" }, ;
{ "Excel not installed", "Excel no está instalado", "Excel non installé", "Excel não está instalado", ;
"Excel nicht installiert", "Excel non installato" }, ;
{ "Report width is greater than page width", "El ancho del informe es mayor que el ancho de la página", ;
"Largeur du Rapport supérieure à la largeur de la page", "A largura do relátorio é maior que a página", ;
"Breite des Reports ist größer als die Seitenbreite", "La larghezza del report è maggiore della larghezza pagina" }, ;
{ "Export to Excel is available only", "Solo está disponible exportar a Excel", ;
"Export vers Excel uniquement disponible", "Somente a exportação para o Excel está disponível", ;
"Nur Excel-Export ist verfügbar", "Esporta in Excel è disponibile solo" }, ;
{ "for Reports with ::bInit defined", "para reportes con ::bInit definido", "pour Rapports avec ::bInit défini", ;
"para relatórios com ::bInit definido", "Für Berichte, die mit :: bInit definiert sind", ;
"Per i Rapporti con definito ::bInit" }, ;
{ "Printing Preview", "Previsualización de Impresión", "visualisation de l'impression", ;
"Previsualização da impressão", "Druckvorschau", "Anteprima di stampa" }, ;
{ "&File", "&Fichero", "&Fichier", "Ar&quivo", "D&atei", "File" }, ;
{ "&Print", "&Imprimir", "&Imprimer", "&Imprimir", "&Druck", "Stampa" }, ;
{ "Print actual page", "Imprimir la página actual", "Imprimer la Page en Cours", "Imprimir a página atual", ;
"Aktuelle Seite drucken", "Stampa pagina attuale" }, ;
{ "&Exit", "&Salir", "&Quitter", "&Sair", "Exit", "&Uscita" }, ;
{ "Exit from preview", "Salir de la previsualización", "Quitter la Visualisation", "Sair da previsualização", ;
"Verlassen der Vorschau", "Esci da anteprima" }, ;
{ "Page", "Página", "Page", "Página", "Seite", "Pagina" }, ;
{ "&First", "&Primera", "&Première", "&Primeira", "Erste", "Prima" }, ;
{ "Go to first page", "Ir a la primera página", "Aller à la première page", "Ir para primeira página", ;
"Zur ersten Seite", "Vai alla prima pagina" }, ;
{ "&Previous", "&Anterior", "&Précédente", "&Anterior", "Vorherige", "Precedente" }, ;
{ "Go to previous page", "Ir a la página anterior", "Aller à la page précédente", "Ir para página anterior", ;
"Zur vorherigen Seite", "Vai alla pagina precedente" }, ;
{ "&Next", "&Siguiente", "&Suivante", "Pró&xima", "Nächste", "Successiva" }, ;
{ "Go to next page", "Ir a la siguiente página", "Aller à la page suivante", "Ir para a próxima página", ;
"Gehe zur nächsten Seite", "Vai alla pagina successiva" }, ;
{ "&Last", "&Ultima", "&Dernière", "Ú&ltima", "Letzte", "Ultimo" }, ;
{ "Go to last page", "Ir a la última página", "Aller à la dernière page", "Zur letzten Seite", ;
"Vai all'ultima pagina", "" }, ;
{ "&Zoom", "&Zoom", "&Zoom", "&Zoom", "&Zoom", "Zoom" }, ;
{ "Page zoom", "Página ampliada con zoom", "zoom de la page", "zoom da página", "&Seite zoomen", "Zoom della pagina" }, ;
{ "&Normal", "&Normal", "&Normal", "&Normal", "&Normal", "Normale" }, ;
{ "Page unzoom", "Página normal", "Page normale", "Página normal", "Seite ungezoomt", "Pagina eliminare lo zoom" }, ;
{ "&Factor", "&Factor", "&Facteur", "&Fator", "Factor", "Fattore" }, ;
{ "Zoom factor", "Factor de zoom", "Facteur de Zoom", "Fator de zoom", "Zoom-Faktor", "Fattore di zoom" }, ;
{ "Factor", "Factor", "Facteur", "Fator", "Faktor", "Fattore" }, ;
{ "&Two pages", "&Dos páginas", "&Deux pages", "&Duas páginas", "Zwei Seiten", "Due pagine" }, ;
{ "Preview on two pages", "Previsualización en dos páginas", "Visualiser sur deux pages", ;
"Previsualização em duas páginas", "Vorschau auf zwei Seiten", "Anteprima su due pagine" }, ;
{ "One &page", "Una &página", "une &page", "Uma pá&gina", "Eine Seite", "Una pagina" }, ;
{ "Preview on one page", "Previsualización en una página", "Visualiser sur une page", ;
"Previsualização em uma página", "Vorschau auf einer Seite", "Anteprima di una pagina" }, ;
{ "Page number:", "Número de página:", "Numéro de la Page:", "Número de página:", "Seitenzahl:", "Numero di pagina:" }, ;
{ "Go to first page", "Ir a la primera página", "Aller à la première page", "Ir para a primeira página", "Zur ersten Seite", "Vai alla prima pagina" }, ;
{ "First", "Primera", "Première", "Primeira", "Erste", "Prima" }, ;
{ "&Page", "&Página", "&Page", "Pá&gina", "Seite", "Pagina" }, ;
{ "Preview on one page", "Previsualización en una página", "Visualiser sur une page", "Previsualização em uma página", "Vorschau auf einer Seite", "Anteprima di una pagina" }, ;
{ "Previous", "Anterior", "Précédente", "Anterior", "Zurück", "Precedente" }, ;
{ "Next", "Siguiente", "Suivante", "Próxima", "Weiter", "Successiva" }, ;
{ "Last", "Ultima", "Dernière", "Última", "Letzte", "Ultimo" }, ;
{ "Zoom", "Aumentar", "Zoom", "Aumentar", "Zoom", "Zoom" }, ;
{ "Two pages", "Dos páginas", "Deux pages", "Duas páginas", "Zwei Seiten", "Due pagine" }, ;
{ "Print", "Imprimir", "Imprimer", "Imprimir", "Druck", "Stampa" }, ;
{ "Save to DOC/PDF", "Guardar como DOC/PDF", "Enregistrer Format DOC/PDF", "Salvar como DOC/PDF", ;
"Speichern als DOC/PDF", "Salva per DOC / PDF" }, ;
{ "DOC Format", "Formato DOC", "Format DOC", "Formato DOC", "DOC-Format", "DOC Formato" }, ;
{ "PDF Format", "Formato PDF", "Format PDF", "Formato PDF", "PDF-Format", "Formato PDF" }, ;
{ "Export to PDF", "Exportar a PDF", "Exporter en PDF", "Exportar para PDF", "Export nach PDF", ;
"Esportazione in formato PDF" }, ;
{ "Send by email as PDF", "Enviar por email como PDF", "Evnoi par email format PDF", "Enviar PDF por email", ;
"PDF Senden per E-Mail", "Invia per e-mail in formato PDF" }, ;
{ "Export to MS Word", "Exportar a MS Word", "Exporter vers MS Word", "Exportar para MS Word", ;
"Export nach MS Word", "Esporta in MS Word" }, ;
{ "Export to Excel", "Exportar a Excel", "Exporter vers Excel", "Exportar para Excel", "Export nach Excel", ;
"Esporta in Excel" }, ;
{ "Exit", "Salir", "Quitter", "Sair", "Ende", "Exit" }, ;
{ "Preview", "Previsualización", "Visualisation", "Previsualização", "Vorschau", "Anteprima" }, ;
{ "Save as", "Guardar como", "Enregistrer Sous", "Salvar como", "Speichern unter", "Salva con nome" }, ;
{ "Printing", "Imprimiendo", "Impression", "Imprimindo", "Drucke", "Stampa" }, ;
{ "Printing page", "Imprimiendo página", "Impression", "Imprimindo", "Druck von Seite", "Stampa" }, ;
{ "&Ok", "&Aceptar", "&OK", "C&onfirmar", "&Ok", "Ok" }, ;
{ "&Cancel", "&Cancelar", "&Annuler", "&Cancelar", "Abbrechen", "Annulla" }, ;
{ "Printing range", "Rango de impresión", "Portée Impression", "Intervalo de impressão", "Druckseitenbereich", ;
"Intervallo di stampa" }, ;
{ "All", "Todo", "Toutes", "Todo", "Alle", "Tutto" }, ;
{ "Current page", "Página actual", "Page en cours", "Página atual", "Aktuelle Seite", "La pagina attuale" }, ;
{ "Pages", "Páginas", "Pages", "Páginas", "Seiten", "Pagine" }, ;
{ "From", "Desde", "De", "De", "Von", "Da" }, ;
{ "To", "Hasta", "A", "Até", "Bis", "A" }, ;
{ "Undo", "Deshacer", "Annuler", "desfazer", "Rückgängig", "Undo" }, ;
{ "Redo", "Rehacer", "Rétablir", "Refazer", "Redo", "Redo" }, ;
{ "Cut", "Cortar", "couper", "Corte", "Schneiden", "Tagliare" }, ;
{ "Copy", "Copiar", "Copier", "cópia", "Kopieren", "Copia" }, ;
{ "Copy to clipboard", "Copiar al portapapeles", "Copier", "cópia", "Kopieren", "Copia" }, ;
{ "Copy to clipboard", "Copiar al portapapeles", "Copier dans le Presse-papiers", "Copiar para área de tranferência", "In die Zwischenablage kopieren", "Copia negli appunti" }, ;
{ "Paste", "Pegar", "coller", "colar", "Einfügen", "Incolla" }, ;
{ "Delete", "Eliminar", "Supprimer", "Excluir", "Löschen", "Elimina" }, ;
{ "Font", "Fuente", "Police", "Font", "Schriftart", "Carattere" }, ;
{ "Print", "Imprimir", "Imprimer", "Imprimir", "Druck", "Stampa" }, ;
{ "Select All", "Seleccionar Todo", "Sélectionner Tout", "Selecionar tudo", "Alle Auswählen", "Seleziona Tutto" }, ;
{ "Align", "Alinear", "Aligner", "Alinhar", "Ausrichten", "Allinea" }, ;
{ "Left", "Izquierda", "Gauche", "à esquerda", "Links", "Sinistra" }, ;
{ "New", "Nuevo", "Nouveau", "Novo", "Neu", "Nuovo" }, ;
{ "ADO open", "ADO abrir", "ADO ouvrir", "ADO abrir", "ADO öffnen", "Apri ADO" }, ;
{ "Open", "Abrir", "ouvrir", "Abrir", "Öffnen", "Aprire" }, ;
{ "Center", "Centro", "Centrer", "center", "Mitte", "Centro" }, ;
{ "Right", "Derecha", "Droite", "certo", "Rechts", "Giusto" }, ;
{ "Justify", "Justificar", "Justifier", "justificar", "Ausrichten", "Giustifica" }, ;
{ "Attention", "¡Atención", "Attention", "Atenção", "Achtung", "Attenzione" }, ;
{ "Information", "Información", "Informations", "Informações", "Information","Informazioni" }, ;
{ "Wrong predefined cursor type!", "Wrong tipo de cursor predefinido!", "Mauvais catégorie de curseur prédéfini!" , ;
"Tipo cursor predefinido errado!", "Falscher vordefinierter Cursor-Typ!", "Tipo di cursore predefinito errato!" }, ;
{ "Want to end ?", "¿ Desea terminar ?", "Veulent mettre fin ? ", "Quer terminar ?", "Möchten Sie Beenden ?", "Vuoi terminare ?" },;
{ "Recent files", "Ficheros recientes", "Fichiers recents", "Arquivos recentes","Zuletzt verwendet","File recenti" },;
{ "Open this file", "Abrir este fichero", "Ouvrir ce fichier", "Abrir este arquivo","Datei öffnen","Apri questo file" },;
{ "Recent ADO connections", "Conexiones ADO recientes", "Connections ADO recentes", "Conecções ADO recentes","Zuletzt verwendete ADO-Verbindungen", "Connessioni ADO recenti" },;
{ "Recent ADO connections strings", "Cadenas de conexión ADO recientes", "Chaînes de connections ADO recentes", "Cadeias de conecções ADO recentes", "Zuletzt verwendete ADO-Verbindungsdaten", "Recenti stringhe di connessione ADO" },;
{ "Connect to this ADO database", "Conectar a esta base de datos ADO", "Connecter à cette base de données ADO", "Conectar a esta base de dados ADO", "Verbinde zu dieser ADO-Datenbank", "Connettiti con questo database ADO" },;
{ "Preferences", "Preferencias", "Préférences", "Preferências", "Präferenzen", "Preferenze" },;
{ "Natural order", "Orden natural", "Ordre natural", "Ordem natural","Keine Sortierung","Ordinamento naturale" },;
{ "Add", "Añadir", "Ajouter", "Adicionar","Hinzufügen","Aggiungi" },;
{ "Edit", "Editar", "Editer", "Editar","Bearbeiten","Modifica" },;
{ "Del", "Borrar", "Supprimer", "Excluir" ,"Löschen","Elimina"},;
{ "Top", "Inicio", "Début", "Início" ,"Anfang","Inizio"},;
{ "Bottom", "Final", "Fin", "Final","Ende","Fine" },;
{ "Search", "Buscar", "Chercher", "Procurar","Suchen","Ricerca" },;
{ "Index", "Orden", "Ordre", "Ordem" ,"Ordnung","Indice"},;
{ "Filter", "Filtro", "Filtre", "Filtro","Filter","Filtro" },;
{ "Relations", "Relaciones", "Relations", "Relações","Relation","Relazioni" },;
{ "Process", "Proceso", "Processus", "Processo","Prozess","Processi" },;
{ "Struct", "Estructura", "Structure", "Estrutura","Struktur","Struttura" },;
{ "Imp/Exp", "Imp/Exp", "Imp/Exp", "Imp/Exp","Import/Export","Importa/Esporta" },;
{ "Report", "Reporte", "Rapport", "Relatório","Report","Stampa" },;
{ "FileName", "Nombre del fichero", "Nom du fichier", "Nome do arquivo","Dateiname","Nome file" },;
{ "NON DELETED", "NO BORRADO", "NON SUPPRIMÉ", "NÃO EXCLUIDO","NICHT GELÖSCHT","NON CANCELLATO" },;
{ "nondeleted", "No borrado", "Non supprimé", "Não excluido","nicht gelöscht","Non cancellato" },;
{ "Ordered by", "Ordenado por", "Classé par", "Classificado por" ,"Sortiert nach","Ordinato per"},;
{ "Natural order", "Orden natural", "Ordre naturel", "Ordem natural","Unsortiert","Ordinamento naturale" },;
{ "Edit", "Editar", "Editer", "Editar","Bearbeiten","Modifica" },;
{ "Save", "Guardar", "Enregistrer", "Salvar","Speichern","Salva" },;
{ "Prev", "Anterior", "Anterieur", "Anterior","Vorher","Precedente" },;
{ "Value", "Valor", "Valeur", "Valor","Wert","Valore" },;
{ "Please select", "Por favor seleccione", "Choisissez", "Selecione","Wählen","Seleziona" },;
{ "Please select a DBF", "Por favor seleccione una DBF", "Choisissez un DBF", "Selecione um DBF","Wählen einer DBF","Seleziona un DBF" },;
{ "(Y/N)", "(S/N)", "(O/N)", "(S/N)","(J/N)","(S/N)" },;
{ "Index builder", "Constructor de índices", "Constructeur d´indexes", "Construtor de índices","Index erstellen","Costruzione indici" },;
{ "Expression", "Expresión", "Expression", "Expressão","Ausdruck","Espressione" },;
{ "Tag", "Tag", "Tag", "Tag","Tag","Tag" },;
{ "For", "Para", "Pour", "Para","Wenn","Per" },;
{ "While", "Mientras", "Pendant", "Enquanto","Während","Mentre" },;
{ "Unique", "Unico", "Unique", "Único","Eindeutig","Unico" },;
{ "Descending", "Descendente", "Descendant", "Descendente","Absteigend","Discendente" },;
{ "Memory", "Memoria", "Mémoire", "Memória","Speicher","Memoria" },;
{ "Scope", "Ambito", "Étendue", "Escopo","Sichtbar","Ambito" },;
{ "Record", "Registro", "Enregistrement", "Registro","Datensatz","Record" },;
{ "Rest", "Restantes", "Restant", "Resto","Restliche","Resto" },;
{ "Progress", "Progreso", "Progrès", "Progresso","Fortschritt","Progresso" },;
{ "Create", "Crear", "Créer", "Criar", "Erzeugen", "Creazione" },;
{ "fields", "campos", "champ", "campo","Felder","campi" },;
{ "Name", "Nombre", "Nom", "Nome","Name","Nome" },;
{ "Type", "Tipo", "Type", "Tipo","Typ","Tipo" },;
{ "Len", "Lon", "Lon", "Com","Länge","Lunghezza" },;
{ "Dec", "Dec", "Dec", "Dec","Dezimal","Decimali" },;
{ "Code", "Código", "Code", "Código","Code","Codice" },;
{ "Indexes of ", "Indices de ", "Index de ", "Índices de","Sortierungen von","Indici di" },;
{ "Order", "Orden", "Ordre", "Ordem","Sortierung","Ordine" },;
{ "TagName", "NombreTag", "NomTag", "NomeTag","TagName","Nometag" },;
{ "BagName", "NombreBag", "NomBag", "NomeBag","BagName","Nomebag" },;
{ "BagExt", "ExtBag", "ExtBag", "ExtBag","ExtBag","Bagext" },;
{ "Incremental", "Incremental", "Incrémental", "Incremental","Inkrementell","Incrementale" },;
{ "Key", "Clave", "Clé", "Chave","Schlüssel","Chiave" },;
{ "Help", "Ayuda", "Aide", "Ajuda","Hilfe","Aiuto" },;
{ "Import/Export for ", "Importar/Exportar para ", "Importer/Exporter vers ", "Importar/Exportar para ","Import/Export für ","Importa/Esporta per" },;
{ "PDF files | *.pdf |", "ficheros PDF | *.pdf |", "fichier PDF | *.pdf |", "arquivos PDF | *.pdf |","PDF-Dateien | *.pdf |","File PDF | *.pdf |", "archivi PDF | *.pdf |" },;
{ "Select PDF File to Save", "Seleccione el fichero PDF a guardar", "Choisissez un fichier PDF pour sauvegarder", "Selecione um arquivo PDF para salvar","PDF-Datei zum Speichern auswählen","Seleziona il file pdf da salvare" },;
{ "Alert", "Alerta", "Alerte", "Alerta","Auswahl","Avviso" },;
{ "Select an option", "Seleccione una opción", "Choisissez une option", "Selecione uma opção","Wähle eine Option","Seleziona una opzione" },;
{ "Window", "Ventana", "Fenêtre", "Janela", "Fenster","Finestra" },;
{ "Tile Vertical", "Distribución vertical", "Mosaïque verticale", "Organizar verticalmente","Vertikal anordnen","Titolo verticale" },;
{ "Vertical arranges the windows as nonoverlapping tiles", "Organiza las ventanas verticalmente", "Organise les fenêtres verticalement", "Organiza as janelas verticalemente","Vertikal anordnen (nicht überlappend)","Organizza verticalmente le finestre" },;
{ "Tile Horizontal", "Distribución horizontal", "Mosaïque horizontale", "Organizar horizontalmente","Horizontal anordnen","Distribuzione orizzontale" },;
{ "Horizontal arranges the windows as nonoverlapping tiles", "Organiza las ventanas horizontalmente", "Mosaïque horizontale sans superposition", "Organizar as janelas horizontalmentesem superposição","Horizontal anordnen (nicht überlappend)","Organizza orizzontalmente le finestre" },;
{ "Cascade", "Cascada", "Cascade", "Cascata","Kaskadierend","A cascata" },;
{ "Arranges the windows so they overlap", "Organiza las ventanas para que no se oculten", "Organiser les fenêtres pour qu´elles ne se superposent pas", "Organiza as janelas para que não se sobreponham","Fenster anordnen (überlappend)","Organizza le finestre affinchè non si sovrappongano" },;
{ "Next Window", "Próxima ventana", "Fenêtre suivante", "Próxima janela","Nächstes Fenster","Finestra successiva" },;
{ "File to Save", "Fichero a guardar", "fichier pour sauvegarder", "arquivo para salvar","Datei zum Speichern auswählen", "file da salvare" },;
{ "Selects the next window", "Selecciona la próxima ventana", "Selectionne la fenêtre suivante", "Selecione a próxima janela","Nächstes Fenster auswählen","Seleziona la prossima finestra" },;
{ "Arrange Icons", "Organiza los iconos", "Organise les icônes", "Organiza os ícones","Icons anordnen","Disponi icone" },;
{ "Arrange icons at the bottom of the window", "Organiza los iconos al final de la ventana", "Organiser les icônes au pied de la fenêtre", "Organizar os ícones no pé da janela","Icons am unteren Rand anordnen","Organizza le icone in fondo alla finestra" },;
{ "Iconize All", "Iconiza todas", "Reduire toutes", "Iconizar todas","Alle verbergen","Riduci tutto ad icona" },;
{ "Iconize all open windows", "Iconiza todas las ventanas abiertas", "Reduire toutes les fenêtres ouvertes", "Iconizar todas as janelas abertas","Alle offenen Fenster verbergen","Riduci a icona tuttte le finestre aperte" },;
{ "Close", "Cierra", "Fermer", "Fechar", "Alle", "Chiudi" },;
{ "Close All", "Cierra todas", "Fermer toutes", "Fecha todas","Alle schließen","Chiudi tutto" },;
{ "Close all open windows", "Cierra todas las ventanas abiertas", "Fermer toutes les fenêtres ouvertes", "Fechar todas as janelas abertas","Alle offenen Fenster schließen","Chiudi tutte le finestre aperte" },;
{ "Contents", "Contenidos", "Contenu", "Conteúdo","Inhalte","Contenuti" },;
{ "Show the help contents", "Muestra los contenidos de la ayuda", "Montrer le contenu de l´aide", "Mostrar o conteúdo da ajuda","Hilfethemen","Mostra i contenuti del file di aiuto" },;
{ "Search for Help on...", "Busca en la ayuda por...", "Rechecher de l´aide sur", "Procurar ajuda para","Suche für Hilfe über...","Ricerca nel file di help per..." },;
{ "Search the help for a specific item", "Busca la ayuda para un item específico", "Rechecher de l´aide sur un sujet spécifique", "Procurar ajuda para um ítem espécifico","Suche für Hilfe über ein bestimmtes Thema","Ricerca nel file di help per una specifica parola" },;
{ "Using help", "Usando la ayuda", "Utilisant l´aide", "Usando a ajuda","Hilfe benutzen","Uso dell'help" },;
{ "Show the help index", "Muestra el índice de la ayuda", "Montrer le catalogue de l´aide", "Mostrar o índice da ajuda","Hilfeindex zeigen","Mostra l'indice del file di help" },;
{ "About...", "Acerca de...", "Sur...", "A respeito de...", "Über...","Circa..." },;
{ "Displays program information and copyright", "Muestra información y derechos de copia del programa", "Afficher les informations et droits du programme", "Exibir os direitos e informações do programa","Copyright und Information","Mostra informazioni e copyright del programma" },;
{ "Default RDD", "RDD por defecto", "RDD par défaut", "RDD padrão","Standard für Datenbanktreiber","RDD standard" },;
{ "Open in shared mode", "Abrir en modo compartido", "Ouvrir en mode partagé", "Abrir em modo compartilhado","Öffnen für gemeinsamen Zugriff","Apri in modalità condivisa" },;
{ "No Help file defined with SetHelpFile()", "No se ha definido un fichero de ayuda usando SetHelpFile()", "Aucun fichier d´aide défini avec la fonction SetHelpFile()", "Nãu foi definido um arquivo de ajuda usando SetHelpFile()","Keine Hilfe definiert mit SetHelpFile()","Nessun file di help definito con SetHelpFile()" },;
{ "Want to delete this record ?", "¿ Desea eliminar este registro ?", "Supprimer cet enregistrment?", "Eliminar este registro?","Diesen Datensatz löschen?","Vuoi cancellare questo record ?" },;
{ "Expression builder", "Constructor de expresiones", "Générateur d´expression", "Construtor de expressões","Ausdrücke definieren","Costruzione espressione" },;
{ "Operators", "Operadores", "Operateurs", "Operadores" ,"Operatoren","Operatori" },;
{ "Functions", "Funciones", "Fonctions", "Funções","Funktionen","Funzioni" },;
{ "Relations of", "Relaciones de", "Relations de", "Relações de","Relationen","Relazioni" },;
{ "Rel.", "Rel.", "Rel.", "Rel.","Rel.","Rel." },;
{ "Child Alias", "Alias del hijo", "Alias du fils", "Alias do filho","Kind-Alias","Aree figlio" },;
{ "Additive", "Aditivo", "Additif", "Aditivo","Zusätzlich","Aggiuntive" },;
{ "Scoped", "Con ámbito", "Encadré", "Com ámbito","Sichtbar","Portata" },;
{ "Processes", "Procesos", "Processus", "Processos","Prozesse","Processi" },;
{ "Run", "Ejecutar", "Executer", "Executar","Ausführen","Esegui" },;
{ "DELETED", "BORRADO", "SUPPRIMÉ", "EXCLUIDO","GELÖSCHT","CANCELLATO" },;
{ "Record updated", "Registro actualizado", "Enregistrement actualisé", "Registro atualizado","Datensatz aktualisiert","record modificato" },;
{ "DBF builder", "Constructor de DBF", "Générateur de DBF", "Construtor de DBF","DBF definieren und erzeugen","Costruzione DBF" },;
{ "Field Name", "Nombre campo", "Nom champ", "Nome campo","Feldname","Nome campo" },;
{ "FieldName", "Nombre campo", "Nom champ", "Nome campo","Feldname","Nome campo" },;
{ "Move Up", "Mover arriba", "Déplacer vers le haut", "Mover para cima","Aufwärts bewegen","Muovi in su" },;
{ "Move Down", "Mover abajo", "Déplacer vers le bas", "Mover para cima" ,"Abwärts bewegen","Muovi in giu" },;
{ "DBF Name:", "Nombre DBF:", "Nom DBF:", "Nome DBF:","DBF-Name:","Nome DBF" },;
{ "Language", "Lenguaje", "Idiome", "Idioma" ,"Sprache","Linguaggio" },;
{ "English", "Inglés", "Français", "Português","Englisch","Inglese" },;
{ "Spanish", "Español", "Espagnol", "Espanhol","Spanisch","Spagnolo" },;
{ "French", "Frances", "Français", "Francês","Französisch","Francese" },;
{ "German", "Alemán", "Allemand", "Alemão","Deutsch","Tedesco" },;
{ "Portuguese", "Portugues", "Portugais", "Português","Portugiesisch","Portoghese" },;
{ "Italian", "Italiano", "Italien", "Italiano","Italienisch","Italiano" },;
{ "Databases", "Bases de datos", "Base de données", "Base de dados","Datenbanken","Database" },;
{ "Query", "Consulta", "Requête", "Consulta","Abfrage","Richiesta" },;
{ "Query builder", "Constructor de consultas", "Générateur de requêtes", "Construtor de consultas","Abfrage definieren","Contruzione richiesta" },;
{ "Operation", "Operación", "Operation", "Operação","Operation","Operazione" },;
{ "Equal", "Igual", "Égal", "Igual","Gleich","Uguale" },;
{ "Different", "Diferente", "Different", "Diferente","Verschieden","differenre" },;
{ "Like", "Como", "Comme", "Como","Wie","Simile" },;
{ "Equal", "Igual", "Égal", "Igual","Gleich","Uguale" },;
{ "Select a table", "Seleccionar una tabla", "Choisir un tableau", "Selecionar uma tabela","Wähle eine Tabelle","Selezona una tabella" },;
{ "Delete for", "Borrar por", "Supprimer si", "Excluir se","Lösche wenn","Cancella per" },;
{ "Delete records of", "Borrar registros de", "Supprimer enregistrements de", "Excluir registros de","Lösche Datensätze mit","Cancella records per" },;
{ "For condition", "Condición para", "Condition SI", "Condição SE","Bedingung","Condizione per" },;
{ "While condition", "Condición mientras", "Condition pendant", "Condição enquanto","Solange","Condizione finchè" },;
{ "Total deleted", "Borrados en total", "Total supprimés", "Total excluídos","Insgesamt gelöscht","Tolale cancellati" },;
{ "Number of records", "Número de registros", "Quantité d´enregistrements", "Quantidade de registros","Zahl der Datensätze","Numero di records" },;
{ "Recall", "Recuperar", "Récupérer", "Recuperar","Wiederherstellen","Recupera" },;
{ "The string", "La cadena", "La chaîne", "A cadeia","Das Wort","La stringa" },;
{ "for language", "para el idioma", "pour l´idiome", "para o idioma","für die Sprache","per il linguaggio" },;
{ "defined from", "definida en", "définie à partir de", "definida de","aufgerufen von","definita da" },;
{ "line", "línea", "ligne", "linha","Zeile","linea" },;
{ "is not defined in FWH strings", "no está traducida en las cadenas de FWH", "non traduit dans les chaînes de FWH", "não está traduzida nas cadeias de FWH","ist in den FWH-Strings nicht definiert","Non è definita nelle stringhe FWH" },;
{ "Please add it to FWH\source\function\strings.prg",;
"Por favor incluir en FWH\source\function\strings.prg",;
"Ajouter s´il vouz plait dans FWH\source\function\strings.prg",;
"Bitte ergänze es in FWH\source\function\strings.prg",;
"Pewr vavore caricatela nell'archivio FWH\source\function\strings.prg",;
"Please add it to FWH\source\function\strings.prg" },;
{ "freeimage.dll not found", "no se encuentra freeimage.dll", "manque freeimage.dll", "freeimage.dll não encontrada","Freeimage.dll nicht gefunden","freeimage.dll non trovata" },;
{ "file not found", "fichero no encontrado", "fichier pas trouvé", "arquivo não encontrado" ,"Datei nicht gefunden","Archivio non trovato"},;
{ "¿", "¿", "?", "?","?","?" },;
{ "Excel not installed", "No está instalado Excel", "Excel non installé", "Excel não instalado","Excel nicht gefunden","Excel non installato" },;
{ "Could not set the format", "No puede establecerse el formato", "Il n´a pas été possible d´établir le format", "Não foi possível estabelecer o formato","Kann das Format nicht festlegen","Non posso impostare il formato" },;
{ "No spreadsheet software installed",;
"No hay software instalado para visualizar hojas de cálculo",;
"Il n´y a pas de programme installé por visualiser les feuilles de calcul",;
"Não tem software instalado para visualizar as folhas de cálculo","Keine Tabellekalkulationssoftware installiert","Nessun software di foglio elettronico installato" },;
{ "to column", "hasta la columna", "jusqu´à la colonne", "até a coluna","nach Reihe","alla colonna" },;
{ "to excel", "a excel", "vers excel", "para excel","nach Excel","in excel" },;
{ "to calc", "a hoja de cálculo", "vers feuille de calcul", "para folha de cálculo","nach Calc","in calcolo" },;
{ "to dbf", "a la DBF", "vers DBF", "para DBF","nach DBF","in dbf" },;
{ "Please select a database", "Por favor seleccione una base de datos", "S´il vous plait choisissez une base de données", "Por favor selecione uma base de dados","Bitte wähle eine Datenbank","Seleziona un database" },;
{ "DBF file| *.dbf|Access file| *.mdb|Access 2010 file | *.accdb|SQLite file| *.db|",;
"Fichero DBF| *.dbf|Fichero Access| *.mdb|Fichero Access 2010| *.accdb|Fichero SQLite| *.db|",;
"Fichier DBF| *.dbf|Fichier Access| *.mdb|Fichier Access 2010| *.accdb|Fichier SQLite| *.db|",;
"Arquivo DBF| *.dbf|Arquivo Access| *.mdb|Arquivo Access 2010| *.accdb|Arquivo SQLite| *.db|",;
"DBF Datenbank| *.dbf|Access Datenbank| *.mdb|Access 2010 Datenbank| *.accdb|SQLite Datenbank| *.db|",;
"File DBF| *.dbf|File Access| *.mdb|File Access 2010 |*.accdb|SQLite file| *.db|" },;
{ "Excel", "Excel", "Excel", "Excel", "Excel" },;
{ "Select", "Seleccione", "Sélectionner", "Selecionar", "Wählen", "Selezionare" },;
{ "Modify DBF structure", "Modificar estructura DBF", "Changement structure DBF", "Alterar estrutura do DBF", "DBF-Struktur bearbeiten", "Modifica struttura DBF" },;
{ "Locate and open a file", "Localizar y abrir un fichero", "Trouver et ouvrir un fichier", "Localizar e abrir um arquivo", "Datei auswählen und öffnen", "Selezionare e aprire un file" },;
{ "Create a new file in a new edit window", "Crear un nuevo fichero en una nueva ventana de edición","Creer un nouveau fichier dans une nouvelle fenetre", "Criar um novo arquivo em uma nova janela de edição", "Neue Datei in einem neuen Fenster", "Creare un nuovo file in una nuova finestra di modifica" },;
{ "Save the current file", "Guardar el fichero actual", "Sauvegarder le fichier courant", "Salvar o arquivo Atual", "Aktuelle Datei speichern", "Salvare il file corrente" },;
{ "Close the current file", "Cerrar el fichero actual", "Fermer le fichier courant", "Fechar o arquivo Atual", "Aktuelle Datei schließen", "Chiudere il file corrente" },;
{ "Print the current file", "Imprimir el fichero actual", "Imprimer le fichier courant", "Imprimir o arquivo Atual", "Aktuelle Datei drucken", "Stampare il file corrente" },;
{ "Exit this app", "Salir de esta aplicación", "Quitter cette application", "Sair da aplicação", "Programm beenden", "Uscire da questa applicazione" },;
{ "Project", "Proyecto", "Projet", "Projeto", "Projekt", "Progetto" },;
{ "Open project", "Abrir proyecto", "Ouvrir projet", "Abrir projeto", "Projekt öffnen", "Aprire il progetto" },;
{ "Save project", "Guardar proyecto", "Sauvegarder projet", "Salvar projeto", "Projekt speichern", "Salvare il progetto" }, ;
{ "Printer setup", "Configurar la impresora", "Configuration Imprimante", "Configurar a impressora", "Drucker auswählen", "Configurare la stampante" },;
{ "Change directory", "Cambiar de directorio", "Changer de dossier", "Trocar diretório", "Wechsle Verzeichnis", "Cambiare directory" },;
{ "Close project", "Cerrar proyecto", "Fermer projet", "Fechar o projeto", "Schließe Projekt", "Chiudere il progetto" },;
{ "Add item", "Añadir item", "Ajouter élément", "Adicionar item", "Element hinzufügen", "Aggiungere un elemento" },;
{ "Delete item", "Borrar item", "Supprimer élément", "Apagar item", "Element löschen", "Cancellare un elemento" },;
{ "Open this project", "Abrir este proyecto", "Ouvrir ce projet", "Abrir este projeto", "Dieses Projekt öffnen", "Aprire questo progetto" },;
{ "Undo the previous editor action", "Deshacer la acción previa del editor", "Annuler l'action précédente de l'éditeur", "Desfazer a ação do editor", "Undo der letzten Aktion", "Annullare l'ultima operazione di modifica" },;
{ "Redo the previous undo editor action", "Repetir la acción de deshacer previa del editor","Répeter l'action précédente de l'éditeur", "Repetir a ação de desfazer do editor", "Redo der letzten Undo-Aktion", "Ripetere l'ultima operazione di modifica annullata" },;
{ "Remove the selected text and put it on the clipboard","Quitar el texto seleccionado y ponerlo en el portapapeles", "Effacer le texte sélectionné et le copier dans le presse-papier", "Remover o texto e colocar no porta papéis", "Markierten Text entfernen und in die Zwischenablage kopieren", "Eliminare il testo selezionato e metterlo negli appunti" },;
{ "Copy the selected text to the clipboard", "Copiar el texto seleccionado al portapapeles","Copier le texte sélectionné dans le presse-papier", "Copiar o texto selecionado e colocar no porta papéis", "Markierten Text in die Zwischenablage kopieren", "Copiare il testo selezionato negli appunti" },;
{ "Insert text from the clipboard at the current position","Insertar texto del portapapeles en la posición actual", "Insérer texte du presse-papier à la position courante", "Inserir texto do porta papéis na posição atual", "Füge den Text aus der Zwischenablage an der aktuellen Position ein", "Inserire il testo dagli appunti nella posizione corrente" }, ;
{ "Select all text in the editor", "Seleccionar todo el texto del editor", "Sélectionner tout le texte de l'éditeur", "Selecionar todo o texto do editor", "Alles markieren", "Selezionare tutto il testo nell'editor" },;
{ "Line duplicate", "Duplicar línea", "Dupliquer ligne", "Duplicar linha", "Kopie der Zeile", "Duplicare una linea" },;
{ "Duplicate line actual", "Duplicar la línea actual", "Dupliquer ligne actuelle", "Duplicar linha atual", "Aktuelle Zeile kopieren", "Duplicare la linea corrente" },;
{ "Search for text", "Buscar texto", "Chercher un texte", "Procurar texto", "Nach Text suchen", "Cercare un testo" }, ;
{ "Find next", "Buscar siguiente", "Trouver suivant", "Procurar seguinte", "Nach unten suchen", "Cercare il prossimo" },;
{ "Find next occurrence", "Buscar la siguiente ocurrencia", "Trouver l'occurence suivante", "Procurar a seguinte ocorrência", "Nächstes Vorkommen", "Cercare la prossima occorrenza" },;
{ "Find prev", "Buscar previo", "Trouver précédent", "Procurar prévia", "Nach oben suchen", "Cercare il precedente" },;
{ "Find", "Buscar", "Trouver", "Procurar", "Suchen", "Cercare" },;
{ "Find previous occurrence", "Buscar la ocurrencia previa", "Trouver l'occurence précédente", "Procurar ocorrência prévia", "Vorhergehendes Vorkommen", "Cercare l'occorrenza precedente" },;
{ "Search again", "Buscar de nuevo", "Chercher de nouveau", "Procurar de novo", "Erneut suchen", "Cercare ancora" },;
{ "Repeat the last search or repeat operation", "Repetir la última búsqueda ó repetir la operación", "Répeter la dernière recherche ou répeter l'opération", "Repetir a última procura e repetir a operação", "Wiederhole die letzte Suche oder Aktion", "Ripetere l'ultima ricerca o ripetere l'operazione" },;
{ "Goto line number", "Ir a la línea número", "Aller à la ligne numéro", "Ir para a linha número", "Gehe zur Zeilennummer", "Andare alla linea numero" },;
{ "Replace", "Reemplazar", "Remplacer", "Substituir", "Ersetzen", "Sostituire" },;
{ "Repeat the last search or repeat operation", "Repetir la última búsqueda ó repetir la operación", "Répeter la dernière recherche ou répeter l'opération", "Repetir a última procura e repetir a operação", "Wiederhole die letzte Suche oder Aktion", "Ripetere l'ultima ricerca o ripetere l'operazione" },;
{ "Go to line number", "Ir a la línea número", "Aller à la ligne numéro", "Ir para a linha número", "Gehe zur Zeilennummer", "Andare alla linea numero" },;
{ "Move cursor to a specific line number", "Mover el cursor a un número de línea específico", "Déplacer le curseur vers une ligne spécifique", "Mover o cursor para a linha", "Gehe mit dem Cursor zu einer bestimmten Zeilennummer", "Spostare il cursore ad un numero di linea specifico" },;
{ "Run as script", "Ejecutar como script", "Executer comme un script", "Executar como script", "Ausführen als Skript", "Eseguire come script" },;
{ "Run the current program as a script without building an EXE", "Ejecutar el programa actual como un script sin construir un EXE", "Executer le programme actuel comme un script sans construire un exe", "Executar o programa atual como script sem construir um EXE", "Ausführen des aktuellen Programmes als Skript ohne eine EXE zu erzeugen", "Eseguire il programma corrente come script senza generare l'EXE" },;
{ "Run as .EXE", "Ejecutar como .EXE", "Executer comme un Exe", "Executar como EXE", "Ausführen als EXE", "Eseguire come EXE" },;
{ "Build and run as an EXE", "Construir y ejecutar como un EXE", "Construire et executer comme un Exe", "Construir e executar como EXE", "Erzeugen und Ausführen als EXE", "Generare ed eseguire come EXE" },;
{ "Debug", "Depurar", "Débugger", "Depurar", "Austesten", "Debug" },;
{ "Debug the EXE", "Depurar el EXE", "Débugger l'exe", "Depurar o EXE", "Austesten der EXE", "Eseguire il debug dell'EXE" },;
{ "Arguments", "Argumentos", "Arguments", "Argumentos", "Argument", "Argomenti" },;
{ "Tools", "Herramientas", "Outils", "Ferramentas", "Werkzeuge", "Strumenti" },;
{ "Cmd Window", "Ventana Cmd", "Fenetre de Commandes", "Prompt de comando", "Eingabeaufforderung", "Finestra Cmd" },;
{ "Settings", "Configuraciones", "Configuration", "Configurações", "Einstellungen", "Impostazioni" },;
{ "Configure this menu", "Configurar este menú", "Configurer ce menu", "Configurar este menu", "Konfigurieren dieses Menü", "Configurare questo menu" },;
{ "Project panel", "Panel del proyecto", "Panel de projet", "Painel do projeto", "Projektfenster", "Pannello del progetto" },;
{ "Result panel", "Panel de resultado", "Panel de résultat", "Painel de resultado", "Ergebnisfenster", "Pannello del risultato" },;
{ "Functions panel", "Panel de funciones", "Panel de fonctions", "Painel de funções", "Funktionsfenster", "Pannello delle funzioni" },;
{ "Preferences", "Preferencias", "Préférences", "Preferências", "Bevorzugte Einstellungen", "Preferenze" },;
{ "FiveTech source code editor", "Editor de código fuente de FiveTech", "Editeur de code source Fivetech", "Editor de código fonte da FiveTech", "FiveTech Quellcode-Editor", "Editor di codice sorgente della FiveTech" },;
{ "Run as script", "Ejecutar como script", "Executer comme un script", "Executar como script", "Ausführen als Skript", "Eseguire come script" },;
{ "Build and execute", "Construir y ejecutar", "Construire et executer", "Construir e executar", "Erzeugen und Ausführen", "Generare ed eseguire" },;
{ "Build and execute with debugger", "Construir y ejecutar con depurador", "Construire et executer avec débugger", "Construir e executar com depurador", "Erzeugen und Ausführen mit Austesten", "Generare ed eseguire con il debugger" },;
{ "Debug", "Depurar", "Debug", "Depurar", "Austesten", "Debug" },;
{ "Find previous", "Encontrar el previo", "Trouver précédent", "Procurar prévia", "Nach oben suchen", "Cercare il precedente" },;
{ "Replace", "Reemplazar", "Remplacer", "Substituir", "Ersetzen", "Sostituire" },;
{ "Goto line", "Ir a la línea", "Aller à la ligne", "Ir para a linha", "Gehe zu Zeile", "Andare alla linea" },;
{ "GotoLine", "Ir a la línea", "Aller à la ligne", "Ir para a linha", "Gehe zu Zeile", "Andare alla linea" },;
{ "Source code editor and projects manager", "Editor de código fuente y gestor de proyectos", "Editeur de code et gestionnaire de projets", "Editor de código fonte e gerenciador de projetos", "Quellcode-Editor und Projekt-Manager", "Editor di codice sorgente e gestione progetto" },;
{ "Repeat the last search or repeat option", "Repetir la última búsqueda ó repetir opción", "Répeter la dernière recherche ou répeter l'option", "Repetir última busca e repetir opção", "Wiederhole die letzte Suche oder Aktion", "Ripetere l'ultima ricerca o ripetere l'opzione" },;
{ "Row", "Fila", "Ligne", "Linha", "Reihe", "Riga" },;
{ "Col", "Col", "Colonne", "Coluna", "Spalte", "Colonna" },;
{ "C compiler", "Compilador de C", "Compilateur de C", "Compilador C", "C Compiler", "Compilatore C" },;
{ "general", "general", "general", "geral", "allgemein", "generale" },;
{ "Command line parameters", "Parámetros de la línea de comando", "Paramètre de ligne de commandes", "Parâmetros da linha de comando", "Kommandozeilen-Parameter", "Parametri della linea di comando" },;
{ "Program file", "Fichero de programa", "Fichier de programmes", "Arquivo de programa", "Programmdatei", "File del programma" },;
{ "Header file", "Fichero de cabecera", "Fichier entête", "Arquivo de cabeçalho", "Headerdatei", "File di intestazione" },;
{ "Resource file", "Fichero de recursos", "Fichier ressources", "Arquivo de recursos", "Resourecedatei", "File di risorse" },;
{ "Open any file", "Abrir cualquier fichero", "Ouvrir un fichier quelconque", "Abrir qualquer arquivo", "Öffne eine Datei", "Aprire qualunque tipo di file" },;
{ "Select a file to open", "Seleccionar el fichero a abrir", "Sélectionner un fichier pour ouverture", "Selecionar um arquivo para abrir", "Wähle eine Datei zum Öffnen aus", "Scegliere un file da aprire" },;
{ "Tools settings", "Configuración de herramientas", "Configuration outils", "Configurar ferramentas", "Werkzeugeinstellungen", "Configurare gli strumenti" },;
{ "This", "Esto", "Ce", "Este", "Diese", "Questo" },;
{ "Forward", "Hacia adelante", "Avancer", "Avançar", "Vorwärts", "Avanti" },;
{ "Save the changes ?", "¿ Guardar los cambios ?", "Sauvegarder les changements ?", "Salvar as alterações?", "Die Änderungen speichern ?", "Salvare le modifiche?" },;
{ "File has changed", "El fichero ha cambiado", "Le fichier a changé", "Arquivo modificado", "Die Datei wurde geändert", "Il file è stato modificato" },;
{ "With", "Con", "Avec", "Com", "Mit", "Con" },;
{ "Number", "Número", "Numero", "Número", "Nummer", "Numero" },;
{ "Source editor", "Editor de código", "Editeur code sources", "Editor de código", "Quellcode-Editor", "Editor di codice sorgente" },;
{ "Script error at line", "Error en el script en la línea", "Erreur de script à la ligne", "Erro de script na linha:", "Skriptfehler in Zeile", "Errore nello script alla linea" },;
{ "Project filename", "Nombre de fichero del proyecto", "Nom du fichier du projet", "Nome do arquivo de projeto", "Name der Projektdatei", "Nome file del progetto" },;
{ "is missing", "no se encuentra", "pas trouvé", "Não encontrado", "fehlt", "non trovato" },;
{ "Code separator", "Separador de código", "Séparateur de code", "Separador de Código", "Code Trennzeile", "Separatore di codice" },;
{ "Insert a code separator", "Inserta un separador de código", "Insérer un code séparateur", "Insira um separador de Código", "Code Trennzeile einfügen", "Inserisce un separatore di codice" },;
{ "Search for", "Buscar por", "Chercher", "Procurar por", "Suchen nach", "Cerca" },;
{ "WildSeek", "Busqueda libre", "Recherche étendue", "Busca livre", "Freie Suche", "Ricerca libera" },;
{ "Copy and paste in", "Copie y pegue en", "Copier et Coller dans", "Copiar e colar em", "Kopieren und Einfügen in", "Copiare e incollare in" },;
{ "There are no printers installed!", "¡No hay impresoras instaladas!", "Pas d'imprimante installée", "Não tem impressoras instaladas", "Es sind keine Drucker installiert !", "Nessuna stampante installata" },;
{ "Please exit this application and install a printer", "Por favor salga de la aplicación e instale una impresora", "Veuillez quitter cette application et installer une imprimante", "Por favor, saia desta aplicação e instale uma impressora", "Bitte schließen Sie das Programm und installieren Sie einen Drucker", "Uscire dall'applicazione e installare una stampante" },;
{ "The temporal metafile could not be created", "El metafile temporal no pudo ser creado", "Impossible de créer le fichier metafile", "Metafile temporal, não pôde ser criado", "Die temporäre Meta-Datei konnte nicht erzeugt werden", "Impossibile creare il metafile temporaneo" },;
{ "Printer object Error", "Error objeto impresora", "Erreur Objet Imprimante", "Erro de Objeto da impressora", "Druckerobject-Fehler", "Errore nell'oggetto stampante" },;
{ "Could not create temporary file", "No se pudo crear el fichero temporal", "Ne peut pas créer fichier temporaire", "Não foi possível criar o arquivo temporário", "Die temporäre Datei konnte nicht erzeugt werden", "Impossibile creare il file temporaneo" },;
{ "Please check your free space on your hard drive", "Por favor compruebe el espacio libre en su disco duro", "Controler l'espace disponible de votre disque dur ", "Por favor, verifique o espaço livre no disco rígido(HD)", "Bitte überprüfen Sie den freien Speicherplatz auf Ihrem Festplattenlaufwerk", "Controllare lo spazio disponibile sul disco fisso" },;
{ "and the amount of files handles available.", "y la cantidad de manejadores de ficheros disponibles", "et la quantité de fichiers handle disponible", "e a quantidade de arquivos disponíveis", "und den Wert der möglichen, offenen Dateien", "e i file handle disponibili" },;
{ "Print preview error", "Error del previsualizador de impresión", "Erreur Visualisation Impression", "Erro de pré-visualização da impressão", "Druckvorschau-Fehler", "Errore nell'anteprima di stampa" } }

static aMissing := {}

//----------------------------------------------------------------------------//

function FWString( cString )

   local nAt
     
   if FWLanguageID() == 1
      return cString
   elseif ( nAt := AScan( aStrings, { | aString | Upper( aString[ 1 ] ) == Upper( cString ) } ) ) != 0
      if Len( aStrings[ nAt ] ) >= FWLanguageID()
         return IfNil( aStrings[ nAt ][ FWLanguageID() ], cString )
      endif
   else
      if '&' $ cString
         cString  := StrTran( cString, '&', '' )
         if ( nAt := AScan( aStrings, { | aString | Upper( aString[ 1 ] ) == Upper( cString ) } ) ) != 0
            if Len( aStrings[ nAt ] ) >= FWLanguageID()
               return '&' + IfNil( aStrings[ nAt ][ FWLanguageID() ], cString )
            endif   
         endif
      endif
      MsgInfo( "The string" + ': "' + cString + '" ' + ;
               "for language" + " " + ;
               { "EN", "ES", "FR", "PT", "DE", "IT" }[ FWLanguageID() ] + CRLF + ;
               "defined from" + ": " + ProcName( 1 ) + " " + ;
               "line" + " " + ;
               AllTrim( Str( ProcLine( 1 ) ) ) + " in " + ProcFile( 1 ) + CRLF + ;
               "is not defined in FMC strings" + CRLF + ;
               "Please add it to fivemac/source/function/strings.prg" )
      AAdd( aMissing, cString )
   endif
  
return cString

//----------------------------------------------------------------------------//

function FWSetLanguage( nNewLanguage )

   local nOldLanguage := FWLanguageID()

   if ! Empty( nNewLanguage )
      nLanguage = Max( 1, Min( nNewLanguage, Len( aStrings[ 1 ] ) ) )
   endif   

return nOldLanguage

//----------------------------------------------------------------------------//
/*
function FWAddLanguage( aLang, nLang )

   if ValType( aLang ) == 'A' .and. ! Empty( aLang )
      aStrings    := ArrTranspose( aStrings )
      if nLang == nil .or. nLang > Len( aStrings )
         AAdd( aStrings, aLang )
         nLang := Len( aStrings )
      else
         aStrings[ nLang ] := aLang
      endif
      aStrings    := ArrTranspose( aStrings )
      FWSetLanguage( nLang )
   endif

return nLang
*/

//----------------------------------------------------------------------------//

function FWMissingStrings()

   local cResult := ""

   AEval( aMissing, { | cString | cResult += Space( 7 ) + '{ "' + cString + ;
                                  '", "" },;' + CRLF } )
   if ! Empty( cResult )
         FM_MemoEdit( cResult, FWString( "Copy and paste in" ) + ;
         		 " FWH\source\function\strings.prg" )
   endif

return cResult

//----------------------------------------------------------------------------//

function FWAddString( aString )

return AAdd( aStrings, aString )

//----------------------------------------------------------------------------//

function FWLanguageID()

   if Empty( nLanguage )
      nLanguage   = Max( 1, AScan( { "EN", "ES", "FR", "PT", "DE", "IT" },;
                        Upper( Left( HB_LangSelect(), 2 ) ) ) )
   endif

return nLanguage

//----------------------------------------------------------------------------//

function FWSetDefaultLanguage()
    
    local cLanguage:= DefaultLanguage()
    
    if Empty( nLanguage )
        nLanguage   = Max( 1, AScan( { "EN", "ES", "FR", "PT", "DE", "IT" },;
                                    Upper( Left( cLanguage, 2 ) ) ) )
    endif
    
    FWSetLanguage( nLanguage )
    
return nLanguage

//----------------------------------------------------------------------------//

function DefaultLanguage()
    
return GetCurrentLanguage()

//----------------------------------------------------------------------------//
/*
function FWLoadStrings( cFileName )

   local cLine, n := 1

   DEFAULT cFileName := cFilePath( GetModuleFileName( GetInstance() ) ) + ;
                        "fwstrings.ini"
   
   while ! Empty( cLine := GetPvProfString( "strings", AllTrim( Str( n++ ) ), "", cFileName ) )
      AAdd( aStrings, { AllTrim( StrToken( cLine, 1, "|" ) ),;
                        AllTrim( StrToken( cLine, 2, "|" ) ),;
                        AllTrim( StrToken( cLine, 3, "|" ) ),;
                        AllTrim( StrToken( cLine, 4, "|" ) ),;
                        AllTrim( StrToken( cLine, 5, "|" ) ),;
                        AllTrim( StrToken( cLine, 6, "|" ) ) } )
   end
   
return nil                            
*/
//----------------------------------------------------------------------------//
/*
function FWSaveStrings( cFileName )

   local cText := "[strings]" + CRLF, n

   DEFAULT cFileName := cFilePath( GetModuleFileName( GetInstance() ) ) + ;
                        "fwstrings.ini"

   for n = 1 to Len( aStrings )
      cText += AllTrim( Str( n ) ) + "="
      AEval( aStrings[ n ], { | c | cText += If( c != nil, c, "" ) + "|" } )
      cText += CRLF
   next
   
return nil
*/
//----------------------------------------------------------------------------//
/*
function FWEditStrings()

   XBROWSER aStrings FASTEDIT AUTOSORT SETUP BrwSetup( oBrw )
   
return nil
*/
//----------------------------------------------------------------------------//  
/*
static function BrwSetUp( oBrw )

   oBrw:aCols[ 1 ]:cHeader = "English"
   oBrw:aCols[ 2 ]:cHeader = "Spanish"
   oBrw:aCols[ 3 ]:cHeader = "French"
   oBrw:aCols[ 4 ]:cHeader = "Portuguese"
   oBrw:aCols[ 5 ]:cHeader = "Italian"
   oBrw:aCols[ 6 ]:cHeader = "German"

   AEval( oBrw:aCols, { | oCol | oCol:nWidth := 200 } )

   ADD TO oBrw AT 1 DATA oBrw:BookMark HEADER " Nº "

return nil 
*/
//----------------------------------------------------------------------------//           
