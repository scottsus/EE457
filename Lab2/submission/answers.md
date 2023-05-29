# Review Questions

## Question 1

Some FIFO users prefer to replace the "Full" and "Empty" signals with "Space Available"
and "Data Available" signals to indicate there is room to write a new value or there is a
value available to read, respectively. Given that you can NOT change your original design,
what additional logic could you add at the periphery of your FIFO to adapt it to this new
set of signals?

We can add 2 counters: `data_read` and `data_written`

```
if (data_written - data_read > DEPTH)
begin
   data_available = 1;
   space_available = 0
end
else if (data_written - data_read <= DEPTH)
begin
   data_available = 0;
   space_available = 1;
end
```

## Question 2

In your Part 1 FIFO design, were your `FULL` and `EMPTY` signals Mealy or Moore style outputs?
Support your answer with 2-3 sentences of explanation:

They were Mealy style outputs because they depend on the inputs `ren` and `wen`. That means they
need a wider clock cycle and the outputs come later towards the end of a clock cycle, but they
deal with a smaller number of states compared to Moore style outputs, in which the outputs do not
depend on the inputs.

## Question 3

In the original Part 1 FIFO design, if the producer asserts `WEN` when the FIFO is full, it would
know that its request would be denied and thus would have to wait to write its value. Essentially, the producer could just look at `FULL` to know if its write would be accepted. In your Part 2 FIFO design, can the producer continue just look at `FULL` to know if its write request was processed? If so, please explain briefly. If not, suggest what the producer would use (examine) to know if its write request was processed.

The producer would need to know if the consumer was simultaneously consuming from the buffer, mainly observing the `ren` signal. As the consumer consumes from the buffer, at the end of the clock cycle, that particular entry can be replaced by the new data from the producer, and no data is lost.
