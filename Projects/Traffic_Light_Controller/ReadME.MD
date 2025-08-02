Specifiaction
Traffic Light Controller Specification 

1. Purpose
To control traffic at a four-way intersection by sequencing Green, Yellow, and Red signals for each road in a safe, predictable, and cyclic manner.

2. Functional Requirements
Four Approaches (Sides):
Side 1, Side 2, Side 3, Side 4.
Signal States for Each Side:
Green (Go)
Yellow (Prepare to Stop)
Red (Stop)
Operation Sequence:
Side 1 Green → Side 1 Yellow → Side 2 Green → Side 2 Yellow → Side 3 Green → Side 3 Yellow → Side 4 Green → Side 4 Yellow → repeat.

3. Timing Requirements
Green Period: Long enough to allow vehicle flow ( 10 time units).
Yellow Period: Shorter duration to clear intersection ( 3 time units).
Red Period: Automatically enforced because other sides are Green/Yellow.

4. Control Logic
Finite State Machine (FSM):
States: Represent each unique configuration of lights (8 total).
State Transitions: Triggered by an internal timer reaching the required count for the current state.
Outputs (Lights): Determined solely by the active state (Moore machine).

5. Safety and Constraints
At any time, only one side can be Green or Yellow; all others remain Red.
No skipping of states; sequence is strictly cyclic.
System starts in Side 1 Green on reset.

6. Performance Considerations
Must maintain predictable timing for all sides.
Should allow easy modification of Green/Yellow durations.
FSM structure should support extensions (e.g., pedestrian signals or emergency overrides).

7. Outputs (Specification View)
Light Pattern for Each State:
Green State: Selected side Green; others Red.
Yellow State: Selected side Yellow; others Red.
