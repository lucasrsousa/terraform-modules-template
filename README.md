# 🚀 Template de Repositório Terraform (Infraestrutura como Código)

Este repositório serve como um template padronizado para provisionamento de infraestrutura na **AWS** usando **Terraform**. Ele adota uma arquitetura modular robusta, separação clara entre ambientes (`environments`) e uma funcionalidade essencial de **Inventário Automático de Recursos**.

---

## 🏗️ Estrutura do Projeto

A organização do projeto segue a prática recomendada de separar a **Definição de Módulos** do **Consumo/Execução de Módulos** (Ambientes).

| Diretório | Descrição |
| :--- | :--- |
| **`environments/`** | Contém os arquivos de configuração raiz (`main.tf`, `backend.tf`, etc.) específicos para cada ambiente (ex: `prod`, `dev`). **É aqui que o Terraform é executado.** |
| **`modules/`** | Contém a lógica reutilizável e modularizada de cada recurso/componente da AWS (ex: `vpc`, `subnet`, `dynamodb`). **Essa lógica é agnóstica ao ambiente.** |
| **`modules/core/utils/`** | Contém módulos utilitários, como o módulo `add_item_inventory`. |

**Exemplo de Caminhos Chave:**

* **Ambiente de Produção (Rede):** `./environments/prod/core/network/`
* **Módulo de Subnet:** `./modules/core/network/subnet/`
* **Módulo de Inventário:** `./modules/core/utils/add_item_inventory/`

---

## ⚙️ Conceitos Arquiteturais Chave

### 1. Arquitetura Orientada a `for_each`

Módulos que são comuns criação de múltiplos recursos são projetados para utilizar a metassintaxe **`for_each`** do Terraform.

* **Vantagem:** Permite que um único módulo instancie múltiplos recursos (ex: várias subnets, várias router_table etc.) com base em um mapa de variáveis. Isso garante alta **reutilização** e **dinamismo**.
* **Exemplo:** O módulo `subnet` cria dinamicamente todas as subnets necessárias através da variável de entrada (`var.subnets`).

### 2. 💡 Inventário Automático de Recursos

O repositório possui um mecanismo de inventário automático implementado através do módulo **`modules/core/utils/add_item_inventory`**.

* **Como Funciona:**
    * Cada módulo principal (como `subnet` ou `igw`) contém uma chamada para o `module "inventory_item"` com o atributo `source = "../../utils/add_item_inventory"`.
    * Esta chamada é responsável por registrar metadados essenciais sobre o recurso provisionado (IDs, ARNs, Tags, Versão do Módulo) em uma **Tabela DynamoDB centralizada** (ou outro mecanismo de inventário configurado).
* **Benefícios:**
    * **Visibilidade:** Mantém um registro em tempo real de todos os recursos provisionados e seus atributos.
    * **Auditoria:** Facilita a auditoria e o rastreamento de recursos criados por cada **Stack ID** (`${var.env}/modules/core/network/subnet/${each.key}`).
    * **Governança:** Fornece dados centralizados para ferramentas de governança e monitoramento.
---

### 📝 Exemplo de Dados de Inventário (JSON)

O item completo a ser registrado no seu banco de dados de Inventário (por exemplo, DynamoDB) combina os campos de nível superior do módulo (`stack_id`, `resource_type`, etc.) com o objeto JSON da variável `metadata`.

**(Assumindo: `var.env = "prod"`, `var.aws_region = "us-east-1"`, e `each.key = "nat-gateway-private"` para esta iteração)**

```json
{
  "stack_id": "prod/modules/core/network/nat/nat-gateway-private",
  "resource_type": "nat_gateway",
  "resource_name": "nat-gateway-private",
  "region": "us-east-1",
  "metadata": {
    "resources": {
      "nat_gateway": {
        "nat-gateway-private": {
          "id": "nat-0a1b2c3d4e5f6g7h8",
          "public_ip": "198.51.100.42",
          "allocation_id": "eipalloc-00112233445566778",
          "subnet_id": "subnet-0fedcba9876543210",
          "tags": {
            "Name": "nat-gateway-private",
            "Environment": "prod"
          }
        }
      }
    },
    "modules": [
      "core/network/nat"
    ],
    "version": "2025.11.12"
  }
}