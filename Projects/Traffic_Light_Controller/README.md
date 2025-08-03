
Specification

The traffic light controller is designed to manage a four-way intersection by sequencing Green, Yellow (Orange), and Red signals for each approach in a safe, predictable, and cyclic manner. There are four approaches, referred to as Side 1, Side 2, Side 3, and Side 4. Each side can display three signal states: Green to indicate "Go," Yellow to indicate "Prepare to Stop," and Red to indicate "Stop."

The controller operates in a fixed sequence: Side 1 Green, Side 1 Yellow, Side 2 Green, Side 2 Yellow, Side 3 Green, Side 3 Yellow, Side 4 Green, and Side 4 Yellow, after which the sequence repeats. Green is active for 10 time units to allow sufficient vehicle flow, while Yellow is active for 3 time units to clear the intersection. The Red signal is implicitly enforced since all non-active sides remain Red.

The control logic is implemented as a finite state machine (FSM). Each state represents a unique configuration of signals, resulting in eight states in total. Transitions occur when an internal timer reaches the required count for the current state, and the outputs are determined solely by the active state, following the Moore machine principle.

Safety is ensured by allowing only one side to be Green or Yellow at any given time while all others remain Red. The system follows a strictly cyclic sequence without skipping states and always initializes to Side 1 Green on reset. The design must maintain predictable timing, allow easy modification of Green and Yellow durations, and support future extensions such as pedestrian signals or emergency overrides. The output pattern for each state is straightforward: in a Green state, the selected side is Green while all others are Red; in a Yellow state, the selected side is Yellow while all others are Red.

---

Explanation of the Design

The design is composed of three main components. The first component is the traffic request and priority state machine, which monitors traffic inputs from four directions represented by t\[3:0]. It selects the next side to receive the Green signal based on the last side that was active, ensuring a fair cyclic order so that no side is permanently starved.

The second component is the timing controller, implemented as a counter. This counter generates the timing intervals for each side, holding the Green signal for 50 cycles and the Yellow signal for 5 cycles before signaling the system to move to the next state. It asserts a control signal called next, which triggers the state transitions in the FSM once the current timing phase completes.

The third component is the signal output logic. This block decodes the current state and timing information to drive the actual Red (R), Green (G), and Yellow (O) signals. It ensures that only one side is ever Green or Yellow at a time while all other sides remain Red, thereby maintaining the required safety and operational constraints.

---
