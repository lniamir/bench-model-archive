# BENCH_BSS (Bike-Sharing Service)

## Model Specifications
* **Paper Name:** Modelling bike-sharing service adoption in urban areas: a case study of Vienna
* **Year:** 2024
* **Authors:** Hanbit Lee
* **Calibration Area:** Vienna

## Technical Stack & Environment
* **Language:** Python 3.9
* **Framework:** Mesa Agent-Based Modeling Framework
* **Environment Manager:** `uv` (Native Workspace)

# **The Behavioral Change in Energy Consumption of Households (BENCH) - Bikeshare System (BSS)**

The **BENCH-BSS** model is an agent-based simulation designed to replicate the decision-making process that individuals go through when considering adopting a bike-sharing system (BSS). The model explores how factors such as sociodemographic characteristics, infrastructure, social influences, and policy measures impact both the adoption and continuous use of BSS. By applying behavioral theories, this model seeks to simulate real-world scenarios, offering insights into transportation behavior and supporting sustainable mobility strategies.

## **Project Structure**

- **`main.py`**: Main simulation script.
- **`main_mvp.py`**: Main simulation script for service provision scenario with a multivariate probit model for both docked bikes and dockless e-bikes.
- **`infra_expansion.py`**: Selects optimal locations for new bike stations based on existing bike stations and public transport stops.
- **GeoJSON files**: Spatial data for Vienna.


## Installation & Execution via `uv`

This model utilizes `uv` workspace management. If you don't have `uv` installed, it is a fast, modern Python package and environment manager that replaces `pip` and `poetry` (install it via `curl -LsSf https://astral.sh/uv/install.sh` or `brew install uv`).

To sync the locked project state and execute the simulation, run the following commands in this directory:

```bash
# Automatically install uv (if not present), create .venv, and sync exact dependencies from uv.lock
uv sync

# Execute the simulation entrypoint using the locked environment
uv run python main.py
