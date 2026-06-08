# /// script
# dependencies = [
#   "pynetlogo",
#   "jpype1",
#   "pandas",
#   "matplotlib",
# ]
# ///

import os
from pathlib import Path
import pynetlogo
import pandas as pd
import matplotlib.pyplot as plt

def main():
    script_dir = Path(__file__).resolve().parent

    # 1. Launch NetLogo
    default_netlogo_home = Path(r"C:\Program Files\NetLogo 7.0.4")
    netlogo_home = Path(os.environ.get("NETLOGO_HOME", default_netlogo_home))
    if not netlogo_home.exists():
        raise FileNotFoundError(f"NetLogo installation not found at {netlogo_home}.")

    model_file = script_dir / "BENCH_ v04_ B-NLD.ESP.nlogo"
    if not model_file.exists():
        raise FileNotFoundError(f"NetLogo model file not found at {model_file}.")

    try:
        # Note: You can switch gui=False for much faster runs since we are graphing in Python!
        netlogo = pynetlogo.NetLogoLink(gui=True, netlogo_home=str(netlogo_home))
    except Exception as exc:
        raise RuntimeError("Unable to start NetLogo via jpype.") from exc

    try:
        netlogo.load_model(str(model_file))
        netlogo.command("setup")

        # 2. Set up lists to capture our plotting data over time
        results = []

        print("Running simulation and collecting data...")
        
        # 3. Step through the simulation step-by-step
        # We use a while loop that respects NetLogo's internal 'stop' condition
        while True:
            # Check current year/tick context before running 'go'
            current_year = netlogo.report("year")
            
            # Run one tick
            netlogo.command("go")
            
            # Collect data matching your NetLogo plot logic
            data_point = {
                "year": current_year,
                
                # Awareness Plot
                "Aware_Low": netlogo.report("count turtles with [aware < 4]"),
                "Aware_Medium": netlogo.report("count turtles with [aware >= 4 and aware < 5]"),
                "Aware_High": netlogo.report("count turtles with [aware >= 5 and aware <= 7]"),
                
                # Motivation Plot
                "PN1": netlogo.report("pn1.total"), "PN2": netlogo.report("pn2.total"), "PN3": netlogo.report("pn3.total"),
                "SN1": netlogo.report("sn1.total"), "SN2": netlogo.report("sn2.total"), "SN3": netlogo.report("sn3.total"),
                
                # Save Energy Plot
                "Electricity": netlogo.report("save.elec.com"),
                "Gas": netlogo.report("save.gas.com"),
            }
            
            # Behaviors, Investment, Conservation, & Switching Plots (only recorded if year >= 2017)
            if current_year >= 2017:
                data_point.update({
                    "Behavior_Investment": netlogo.report("a1.com + a2.com + a3.com"),
                    "Behavior_Conservation": netlogo.report("a4.com + a5.com + a6.com"),
                    "Behavior_Switching": netlogo.report("a7.com + a8.com + a9.com"),
                    "I1": netlogo.report("a1"), "I2": netlogo.report("a2"), "I3": netlogo.report("a3"),
                    "C1": netlogo.report("a4"), "C2": netlogo.report("a5"), "C3": netlogo.report("a6"),
                    "S1": netlogo.report("a7"), "S2": netlogo.report("a8"), "S3": netlogo.report("a9")
                })

            results.append(data_point)

            # Check if NetLogo's loop has stopped (either by your custom stop code or running out of ticks)
            # If the model halts, netlogo.report will return None or stay stagnant
            if netlogo.report("year") == current_year: 
                break

        # 4. Process data into a Pandas DataFrame
        df = pd.DataFrame(results).set_index("year")

        # 5. Plotting via Matplotlib 
        print("Generating plots...")
        
        # Plot 1: Awareness
        plt.figure(figsize=(10, 5))
        plt.plot(df.index, df[["Aware_Low", "Aware_Medium", "Aware_High"]])
        plt.title("Awareness Over Time")
        plt.xlabel("Year")
        plt.ylabel("Count")
        plt.legend(["Low", "Medium", "High"])
        plt.grid(True)
        plt.savefig(script_dir / "plot_awareness.png")
        plt.close()

        # Plot 2: Households Behavioral Change (Only plots years where data exists)
        df_behavior = df.dropna(subset=["Behavior_Investment"])
        if not df_behavior.empty:
            plt.figure(figsize=(10, 5))
            plt.plot(df_behavior.index, df_behavior[["Behavior_Investment", "Behavior_Conservation", "Behavior_Switching"]])
            plt.title("Households Behavioral Change")
            plt.xlabel("Year")
            plt.ylabel("Value")
            plt.legend(["Investment", "Conservation", "Switching"])
            plt.grid(True)
            plt.savefig(script_dir / "plot_behaviors.png")
            plt.close()
            
        # Plot 3: Save Energy
        plt.figure(figsize=(10, 5))
        plt.plot(df.index, df[["Electricity", "Gas"]])
        plt.title("Save Energy")
        plt.xlabel("Year")
        plt.ylabel("Value")
        plt.legend(["Electricity", "Gas"])
        plt.grid(True)
        plt.savefig(script_dir / "plot_saveenergy.png")
        plt.close()

        print(f"Done! Plots have been saved to your directory: {script_dir}")

    finally:
        netlogo.kill_workspace()

if __name__ == "__main__":
    main()