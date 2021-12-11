curl -X POST -H 'Content-Type: application/json' 'http://localhost:8983/solr/chess_system/schema' --data-binary '
{
	"add-field-type": [
        
        { 
            "name":"integer",
            "class":"solr.IntPointField"
        },
        {
            
            "name":"openingName",
            "class":"solr.TextField",
            "indexAnalyzer":{
                "tokenizer":{
                    "class":"solr.StandardTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            },
            "queryAnalyzer":{
                "tokenizer":{
                    "class":"solr.StandardTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            }
        },
        {
            "name":"pgnMoves",
            "class":"solr.TextField",
            "indexAnalyzer":{
                "tokenizer":{
                    "class":"solr.LetterTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            },
            "queryAnalyzer":{
                "tokenizer":{
                    "class":"solr.StandardTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            }
        },
        {
            "name":"openingDescription",
            "class":"solr.TextField",
            "indexAnalyzer":{
                "tokenizer":{
                    "class":"solr.StandardTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            },
            "queryAnalyzer":{
                "tokenizer":{
                    "class":"solr.StandardTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            }
        },
        {
            "name":"irlName",
            "class":"solr.TextField",
            "indexAnalyzer":{
                "tokenizer":{
                    "class":"solr.StandardTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            },
            "queryAnalyzer":{
                "tokenizer":{
                    "class":"solr.StandardTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            }
        },
        {
            "name":"playerBio",
            "class":"solr.TextField",
            "indexAnalyzer":{
                "tokenizer":{
                    "class":"solr.StandardTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            },
            "queryAnalyzer":{
                "tokenizer":{
                    "class":"solr.StandardTokenizerFactory"
                },
                "filters":[
                    {"class":"solr.ASCIIFoldingFilterFactory", "preserveOriginal":true},
                    {"class":"solr.LowerCaseFilterFactory"}
                ]
            }
        }
    ],
    "add-field": [
        {
            "name": "opening_id",
            "type": "integer",
            "indexed": false
        },
        {
            "name": "op_name",
            "type": "openingName",
            "indexed": true
        },
        {
            "name": "code",
            "type": "string",
            "indexed": true
        },
        {
            "name": "pgn_moves",
            "type": "pgnMoves",
            "indexed": true
        },
        {
            "name": "op_description",
            "type": "openingDescription",
            "indexed": true
        },
        {
            "name": "is_mainline",
            "type": "boolean",
            "indexed": false
        },
        {
            "name": "player_id",
            "type": "integer",
            "indexed": false
        },
                
        {
            "name": "irl_name",
            "type": "irlName",
            "indexed": true
        },        
        {
            "name": "title",
            "type": "string",
            "indexed": false
        },
        {
            "name": "bio",
            "type": "playerBio",
            "indexed": true
        }
    ]
}

'